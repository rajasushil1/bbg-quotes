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
    
    // IAP Manager for premium status - will be set externally
    private var iapManager: IAPManager?
    
    private override init() {
        super.init()
        MobileAds.shared.start(completionHandler: nil)
    }
    
    // MARK: - Set IAP Manager
    func setIAPManager(_ iapManager: IAPManager) {
        self.iapManager = iapManager
    }
    
    // MARK: - Premium User Check
    private var isPremiumUser: Bool {
        guard let iapManager = iapManager else {
            print("IAPManager not set in AdsManager")
            return false
        }
        let isPremium = !iapManager.purchasedSubscriptions.isEmpty
        print("AdsManager: Premium status check - isPremium: \(isPremium), purchasedSubscriptions count: \(iapManager.purchasedSubscriptions.count)")
        return isPremium
    }
    
    // MARK: - Load Interstitial
    func loadInterstitial() {
        // Don't load ads if user is premium
        guard !isPremiumUser else {
            print("Ads disabled for premium user")
            return
        }
        
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
        // Don't show ads if user is premium
        guard !isPremiumUser else {
            print("Ads disabled for premium user")
            return
        }
        
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
    
    // MARK: - Public Premium Status
    var shouldShowAds: Bool {
        return !isPremiumUser
    }
    
    var premiumStatusText: String {
        return isPremiumUser ? "Premium User - Ads Disabled" : "Free User - Ads Enabled"
    }
    
    var premiumStatusIcon: String {
        return isPremiumUser ? "checkmark.circle.fill" : "xmark.circle.fill"
    }
    
    var premiumStatusColor: Color {
        return isPremiumUser ? .green : .red
    }
}

// MARK: - Smart Banner Ad View for SwiftUI
struct SmartBannerAdView: UIViewRepresentable {
    let adUnitID: String
    @EnvironmentObject var iapManager: IAPManager
    
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        
        // Check premium status through IAPManager
        let isPremiumUser = !iapManager.purchasedSubscriptions.isEmpty
        print("SmartBannerAdView: makeUIView - isPremium: \(isPremiumUser), purchasedSubscriptions count: \(iapManager.purchasedSubscriptions.count)")
        
        if !isPremiumUser {
            banner.load(Request())
        } else {
            banner.isHidden = true
        }
        
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        // Re-check premium status on updates
        let isPremiumUser = !iapManager.purchasedSubscriptions.isEmpty
        print("SmartBannerAdView: updateUIView - isPremium: \(isPremiumUser), purchasedSubscriptions count: \(iapManager.purchasedSubscriptions.count)")
        uiView.isHidden = isPremiumUser
    }
}

// MARK: - Legacy Banner Ad View (deprecated - use SmartBannerAdView instead)
struct BannerAdView: UIViewRepresentable {
    let adUnitID: String
    
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        
        // Check if user is premium before loading banner ad
        let iapManager = IAPManager()
        let isPremiumUser = !iapManager.purchasedSubscriptions.isEmpty
        
        if !isPremiumUser {
            banner.load(Request())
        } else {
            // Hide the banner completely for premium users
            banner.isHidden = true
        }
        
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        // Re-check premium status on updates
        let iapManager = IAPManager()
        let isPremiumUser = !iapManager.purchasedSubscriptions.isEmpty
        
        if isPremiumUser {
            uiView.isHidden = true
        } else {
            uiView.isHidden = false
        }
    }
}

