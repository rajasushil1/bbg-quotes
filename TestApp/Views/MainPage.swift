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
            appearance.backgroundColor = UIColor.black
            appearance.stackedLayoutAppearance.selected.iconColor = .white
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.stackedLayoutAppearance.normal.iconColor = .gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
           
        }
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
                

            FeedPage()
                .tabItem {
                    Label("Order", systemImage: "square.and.pencil")
                }
               
            SettingsPage()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
               
        }
        .accentColor(.white)
    }
}
