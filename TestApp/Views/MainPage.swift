//
//  MainPage.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//
import SwiftUI
import UIKit

struct MainView: View {
    init() {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
            appearance.stackedLayoutAppearance.selected.iconColor = .orange
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.orange]
            appearance.stackedLayoutAppearance.normal.iconColor = .gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
           
        }
    var body: some View {
        TabView {
            FeedPage()
//            TestPage1()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ContentView()
//            TestPage1()
                .tabItem {
                    Label("Book", systemImage: "book.fill")
                }
            SettingsPage()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
               
        }
        .accentColor(.white)
    }
}
#Preview {
    MainView()
}
