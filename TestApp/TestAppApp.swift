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
    @StateObject private var notificationManager = NotificationManager.shared
    
    init() {
        // Set up notification delegate
        UNUserNotificationCenter.current().delegate = notificationManager
        
        // Set up notification categories
        notificationManager.setupNotificationCategories()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(notificationManager)
        }
    }
}
