//
//  MainPage.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//
import SwiftUI
import UIKit
import AppTrackingTransparency

struct MainView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Set a light background color for better contrast
        appearance.backgroundColor = UIColor.systemBackground
        
        // Configure selected tab appearance with better contrast
        appearance.stackedLayoutAppearance.selected.iconColor = .orange
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.orange,
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        // Configure normal tab appearance
        appearance.stackedLayoutAppearance.normal.iconColor = .systemGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        
        // Apply the appearance to both standard and scroll edge
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // Ensure proper contrast on iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            UITabBar.appearance().backgroundColor = UIColor.systemBackground
        }
    }
    
    var body: some View {
        TabView {
            FeedPage()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ContentView()
                .tabItem {
                    Label("Book", systemImage: "book.fill")
                }
            SettingsPage()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .onAppear {
            requestTrackingAuthorizationIfNeeded()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            requestTrackingAuthorizationIfNeeded()
        }
        // Remove the conflicting accentColor modifier
    }
}

private func requestTrackingAuthorizationIfNeeded() {
    if #available(iOS 14, *) {
        let status = ATTrackingManager.trackingAuthorizationStatus
        if status == .notDetermined {
            DispatchQueue.main.async {
                ATTrackingManager.requestTrackingAuthorization { _ in }
            }
        }
    }
}

#Preview {
    MainView()
}
