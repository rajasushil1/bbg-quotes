//
//  NotificationManager.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//

import Foundation
import UserNotifications
import SwiftUI

@MainActor
class NotificationManager: NSObject, ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    @Published var notificationsEnabled = false
    
    private let userDefaults = UserDefaults.standard
    private let notificationsEnabledKey = "notificationsEnabled"
    
    private override init() {
        super.init()
        loadSettings()
        checkAuthorizationStatus()
    }
    
    // MARK: - Public Methods
    
    func requestAuthorization() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            )
            
            await MainActor.run {
                self.isAuthorized = granted
                if granted {
                    self.scheduleNotificationsIfEnabled()
                }
            }
        } catch {
            await MainActor.run {
                self.isAuthorized = false
            }
        }
    }
    
    func toggleNotifications(_ enabled: Bool) {
        notificationsEnabled = enabled
        userDefaults.set(enabled, forKey: notificationsEnabledKey)
        
        if enabled {
            if isAuthorized {
                scheduleNotifications()
            } else {
                Task {
                    await requestAuthorization()
                }
            }
        } else {
            cancelAllNotifications()
        }
    }
    
    func scheduleNotifications() {
        guard isAuthorized && notificationsEnabled else { return }
        
        // Cancel existing notifications first
        cancelAllNotifications()
        
        // Schedule new daily notification
        scheduleDailyNotification()
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    // MARK: - Private Methods
    
    private func loadSettings() {
        notificationsEnabled = userDefaults.bool(forKey: notificationsEnabledKey)
    }
    
    private func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.isAuthorized = settings.authorizationStatus == .authorized
                
                // If notifications are enabled in settings but not authorized, disable them
                if self.notificationsEnabled && !self.isAuthorized {
                    self.notificationsEnabled = false
                    self.userDefaults.set(false, forKey: self.notificationsEnabledKey)
                }
                
                // If authorized and enabled, schedule notifications
                if self.isAuthorized && self.notificationsEnabled {
                    self.scheduleNotifications()
                }
            }
        }
    }
    
    private func scheduleNotificationsIfEnabled() {
        if notificationsEnabled {
            scheduleNotifications()
        }
    }
    
    private func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Inspiration"
        content.subtitle = "Start your day with wisdom"
        content.body = getRandomNotificationMessage()
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "DAILY_INSPIRATION"
        
        // Create notification trigger for daily at random time between 6:30 AM - 7:30 AM
        let trigger = createDailyNotificationTrigger()
        
        let request = UNNotificationRequest(
            identifier: "dailyMorningNotification",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            // Handle any errors silently in production
        }
    }
    
    private func createDailyNotificationTrigger() -> UNNotificationTrigger {
        let calendar = Calendar.current
        
        // Get current date components
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        
        // Set time to random time between 6:30 AM and 7:30 AM
        let randomMinutes = Int.random(in: 0...60)
        dateComponents.hour = 6
        dateComponents.minute = 30 + randomMinutes
        
        // If the time has passed today, schedule for tomorrow
        if let scheduledDate = calendar.date(from: dateComponents), scheduledDate <= Date() {
            dateComponents.day! += 1
        }
        
        // Create trigger that repeats daily
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        return trigger
    }
    
    private func getRandomNotificationMessage() -> String {
        let messages = [
            "Start your day with wisdom from the Bhagavad Gita",
            "A new day brings new opportunities for spiritual growth",
            "Find peace and wisdom in today's teachings",
            "Let the ancient wisdom guide your path today",
            "Embrace the divine knowledge within you",
            "Today is perfect for spiritual reflection",
            "Discover inner peace through sacred wisdom",
            "Let the Gita illuminate your journey"
        ]
        
        return messages.randomElement() ?? "Start your day with wisdom from the Bhagavad Gita"
    }
    
    // MARK: - Notification Content Management
    
    func updateNotificationContent() {
        // This method can be called to update notification content
        // For example, when new quotes are available
        if notificationsEnabled {
            scheduleNotifications()
        }
    }
    
    // MARK: - Utility Methods
    
    func getNextNotificationTime() async -> Date? {
        let center = UNUserNotificationCenter.current()
        var nextDate: Date?
        
        let requests = await center.pendingNotificationRequests()
        
        for request in requests {
            if let trigger = request.trigger as? UNCalendarNotificationTrigger,
               let nextTriggerDate = trigger.nextTriggerDate() {
                if nextDate == nil || nextTriggerDate < nextDate! {
                    nextDate = nextTriggerDate
                }
            }
        }
        
        return nextDate
    }
    
    func getNotificationStatus() -> String {
        if !isAuthorized {
            return "Notifications not authorized"
        } else if !notificationsEnabled {
            return "Get notified about new content"
        } else {
            return "Notifications are enabled"
        }
    }
    
    func getDetailedNotificationStatus() async -> String {
        if !isAuthorized {
            return "Notifications not authorized"
        } else if !notificationsEnabled {
            return "Get notified about new content"
        } else {
            if let nextTime = await getNextNotificationTime() {
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                formatter.dateStyle = .short
                return "Next notification: \(formatter.string(from: nextTime))"
            } else {
                return "Notifications are enabled"
            }
        }
    }
    
    // MARK: - Testing Methods (for development)
    
    // func sendTestNotification() {
    //     guard isAuthorized else { return }
        
    //     let content = UNMutableNotificationContent()
    //     content.title = "Test Notification"
    //     content.subtitle = "This is a test"
    //     content.body = "This is a test notification from your app"
    //     content.sound = .default
    //     content.badge = 1
        
    //     // show this notification five seconds from now
    //     let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
    //     // choose a random identifier
    //     let request = UNNotificationRequest(
    //         identifier: UUID().uuidString, 
    //         content: content, 
    //         trigger: trigger
    //     )
        
    //     // add our notification request
    //     UNUserNotificationCenter.current().add(request) { error in
    //         // Handle any errors silently in production
    //     }
    // }
}

// MARK: - Notification Delegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Handle notification tap
        switch response.actionIdentifier {
        case "VIEW_ACTION":
            // Navigate to main content
            break
        case "DISMISS_ACTION":
            // Dismiss notification
            break
        default:
            // Default tap action
            break
        }
        
        completionHandler()
    }
}

// MARK: - Notification Categories

extension NotificationManager {
    func setupNotificationCategories() {
        let viewAction = UNNotificationAction(
            identifier: "VIEW_ACTION",
            title: "View",
            options: .foreground
        )
        
        let dismissAction = UNNotificationAction(
            identifier: "DISMISS_ACTION",
            title: "Dismiss",
            options: .destructive
        )
        
        let category = UNNotificationCategory(
            identifier: "DAILY_INSPIRATION",
            actions: [viewAction, dismissAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}

// MARK: - Async Authorization Check

extension NotificationManager {
    private func checkAuthorizationStatusAsync() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        
        await MainActor.run {
            self.isAuthorized = settings.authorizationStatus == .authorized
        }
    }
}
