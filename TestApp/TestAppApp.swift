//
//  TestAppApp.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//

import SwiftUI
import UserNotifications

@main
struct TestAppApp: App {
    
    init() {
        // Set up notification delegate
        UNUserNotificationCenter.current().delegate = NotificationManager.shared
        
        // Set up notification categories
        NotificationManager.shared.setupNotificationCategories()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(NotificationManager.shared)
        }
    }
}
