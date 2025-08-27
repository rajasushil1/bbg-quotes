//
//  AdsTestView.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 27/08/2025.
//

import SwiftUI

struct AdsTestView: View {
    @StateObject private var adsManager = AdsManager.shared
    @EnvironmentObject var iapManager: IAPManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, SwiftUI + Ads!")
                .font(.largeTitle)
                .padding()
            
            // Premium Status Display - using AdsManager
            HStack {
                Image(systemName: adsManager.premiumStatusIcon)
                    .foregroundColor(adsManager.premiumStatusColor)
                    .font(.title2)
                
                Text(adsManager.premiumStatusText)
                    .font(.headline)
                    .foregroundColor(adsManager.premiumStatusColor)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
            
            // Use SmartBannerAdView which automatically handles premium status
            SmartBannerAdView(adUnitID: adsManager.bannerAdUnitID)
                .frame(width: 320, height: 50)
            
            // Ad control buttons - automatically disabled for premium users
            Button("Load Interstitial") {
                adsManager.loadInterstitial()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!adsManager.shouldShowAds)
            
            Button("Show Interstitial") {
                if let root = UIApplication.shared.windows.first?.rootViewController {
                    adsManager.showInterstitial(from: root)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(!adsManager.shouldShowAds)
            
            // Show message if premium user
            if !adsManager.shouldShowAds {
                Text("Ad controls disabled for premium users")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .onAppear {
            // Set the IAPManager in AdsManager so it can check premium status
            adsManager.setIAPManager(iapManager)
        }
    }
}

#Preview {
    AdsTestView()
}
