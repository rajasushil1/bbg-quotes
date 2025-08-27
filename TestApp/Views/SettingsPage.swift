//
//  SettingsPage.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//

import SwiftUI
import StoreKit

struct SettingsPage: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    @StateObject private var notificationManager = NotificationManager.shared
    @AppStorage("adsRemoved") private var adsRemoved = false
    
    var body: some View {
        NavigationView {
            List {
                // Remove Ads Section
                Section {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Remove Ads")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(adsRemoved ? "Ads are disabled" : "Remove all advertisements")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if adsRemoved {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                        } else {
                            Button("Remove") {
                                // In a real app, this would trigger in-app purchase
                                adsRemoved = true
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                        }
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Premium Features")
                }
                
                // Notifications Section
                Section {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Notifications")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(notificationManager.getNotificationStatus())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if !notificationManager.isAuthorized {
                            Button("Enable") {
                                Task {
                                    await notificationManager.requestAuthorization()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                        } else {
                            Toggle("", isOn: $notificationManager.notificationsEnabled)
                                .labelsHidden()
                                .onChange(of: notificationManager.notificationsEnabled) { newValue in
                                    notificationManager.toggleNotifications(newValue)
                                }
                        }
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Preferences")
                }
                
                // Favourite Quotes Section
                Section {
                    NavigationLink(destination: FavoritesView()) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Favourite Quotes")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text("\(favoritesManager.favoriteQuotes.count) saved quotes")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("Content")
                }
                
                // Support Section
                Section {
                    // Contact Us
                    Button(action: {
                        contactUs()
                    }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Contact Us")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Text("Get in touch with our support team")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        .padding(.vertical, 4)
                    }
                    
                    // Privacy Policy
                    Button(action: {
                        showPrivacyPolicy()
                    }) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(.purple)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Privacy Policy")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Text("Read our privacy policy")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        .padding(.vertical, 4)
                    }
                    
                    // Rate Us
                    Button(action: {
                        rateApp()
                    }) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Rate Us")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Text("Rate us on the App Store")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("Support")
                }
                
                // App Info Section
                Section {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("App Version")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("1.0.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                // Automatically request notification permissions when settings page appears
                if !notificationManager.isAuthorized {
                    Task {
                        await notificationManager.requestAuthorization()
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func contactUs() {
        // In a real app, this would open email or contact form
        if let url = URL(string: "mailto:support@testapp.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func showPrivacyPolicy() {
        // In a real app, this would show privacy policy
        if let url = URL(string: "https://testapp.com/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        // Request App Store review
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

// MARK: - Favorites View

struct FavoritesView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        VStack {
            if favoritesManager.favoriteQuotes.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "heart")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No Favorite Quotes Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Tap the heart button on any quote to add it to your favorites")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(favoritesManager.favoriteQuotes) { quote in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(quote.title)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("\(quote.description)")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(3)
                            
                            Text("— \(quote.author)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .italic()
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete(perform: deleteFavorites)
                }
            }
        }
        .navigationTitle("Favourite Quotes")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func deleteFavorites(offsets: IndexSet) {
        for index in offsets {
            let quote = favoritesManager.favoriteQuotes[index]
            favoritesManager.removeFavorite(quote)
        }
    }
}

#Preview {
    SettingsPage()
}
