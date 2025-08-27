//
//  AdsTestView.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 27/08/2025.
//

import SwiftUI

struct AdsTestView: View {
    @StateObject private var adsManager = AdsManager.shared
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Hello, SwiftUI + Ads!")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                
                BannerAdView(adUnitID: adsManager.bannerAdUnitID)
                    .frame(width: 320, height: 50)
                
                Button("Load Interstitial") {
                    adsManager.loadInterstitial()
                }
                
                Button("Show Interstitial") {
                    if let root = UIApplication.shared.windows.first?.rootViewController {
                        adsManager.showInterstitial(from: root)
                    }
                }
            }
            .padding()
        }
    }

#Preview {
    AdsTestView()
}
