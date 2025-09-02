//
//  SettingsPage.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//

import SwiftUI
import StoreKit

struct SettingsPage: View {
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    @ObservedObject private var notificationManager = NotificationManager.shared
    @ObservedObject private var iapManager = IAPManager()
    @State private var showSubscriptionPage: Bool = false
    
    // Computed property to check if user is premium
    private var isPremiumUser: Bool {
        return !iapManager.purchasedSubscriptions.isEmpty
    }
    
    var body: some View {
        NavigationView {
            List {
                // Remove Ads Section
                Section {
                   
                    Button(action: {
                        // 👉 Your button action goes here
                       showSubscriptionPage = true
                    }) {
                        HStack {
                            Image(systemName: isPremiumUser ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(isPremiumUser ? .green : .red)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(isPremiumUser ? "Ads Removed" : "Remove Ads")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Text(isPremiumUser ? "Ads are removed for you" : "Remove all advertisements")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .disabled(isPremiumUser)

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
            }.fullScreenCover(isPresented: $showSubscriptionPage) {
               PremiumDescriptionPage()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Actions
    
    private func contactUs() {
        // In a real app, this would open email or contact form
        if let url = URL(string: "https://appsved.com/contact-us") {
            UIApplication.shared.open(url)
        }
    }
    
    private func showPrivacyPolicy() {
        // In a real app, this would show privacy policy
        if let url = URL(string: "https://appsved.com/privacy-policy") {
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
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    @Environment(\.presentationMode) var presentationMode
    
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
        .navigationBarTitleDisplayMode(.automatic)
        .accentColor(.black)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.black)
                }
            }
        }
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
