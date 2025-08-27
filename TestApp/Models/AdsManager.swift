//
//  AdsManager.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 27/08/2025.
//

import SwiftUI
import GoogleMobileAds

// MARK: - Ads Manager
class AdsManager: NSObject, ObservableObject, FullScreenContentDelegate {
    
    static let shared = AdsManager()  // Singleton
    
    // MARK: - AdMob IDs
    let appID = "ca-app-pub-3940256099942544~1458002511" // Test App ID
    let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716" // Test Banner
    let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910" // Test Interstitial
    
    // Interstitial property
    private var interstitial: InterstitialAd?
    
    private override init() {
        super.init()
        MobileAds.shared.start(completionHandler: nil)
    }
    
    // MARK: - Load Interstitial
    func loadInterstitial() {
        let request = Request()
        InterstitialAd.load(with: interstitialAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
            print("Interstitial loaded successfully")
        }
    }
    
    // MARK: - Show Interstitial
    func showInterstitial(from rootViewController: UIViewController) {
        if let ad = interstitial {
            ad.present(from: rootViewController)
        } else {
            print("Interstitial not ready")
        }
    }
    
    // MARK: - GADFullScreenContentDelegate
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Interstitial dismissed")
        interstitial = nil
        loadInterstitial() // Preload next ad
    }
}

// MARK: - Banner Ad View for SwiftUI
struct BannerAdView: UIViewRepresentable {
    let adUnitID: String
    
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(Request())
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {}
}

