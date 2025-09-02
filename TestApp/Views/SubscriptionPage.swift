//
//  SubscriptionPage.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 27/08/2025.
//

import Foundation
import SwiftUI
import StoreKit

struct PremiumDescriptionPage: View {
    @EnvironmentObject var iapManager: IAPManager
    @State var isPurchased = false
    @State var subscriptionIndex = 0
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var isPurchasing = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient - same as book page
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange.opacity(0.1), Color.yellow.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
              
                    VStack(spacing: 30) {
                        
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            headerSection
                          
                            
                            // Subscription options
                            subscriptionOptionsSection
                            
                            // Continue button
                            continueButtonSection
                        }
                        else{
                            // Header section
                            headerSection
                            Spacer()
                            
                            // Subscription options
                            subscriptionOptionsSection
                            Spacer()
                            // Continue button
                            continueButtonSection
                        }
                        

                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
              
                
                // Header overlay
                HeaderForAll(titleText: "")
            }
            .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Close button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                Spacer()
                
                Button(action: {
                    restorePurchases()
                }) {
                    Text("Restore")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.orange, Color.red]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
            
            // Title and subtitle
            VStack(spacing: 12) {
                Text("Remove Ads")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Enjoy an ad-free experience with npremium subscription")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 10)
            }
        }.padding(.top, 20)
    }
    
    // MARK: - Subscription Options Section
    private var subscriptionOptionsSection: some View {
        VStack(spacing: 20) {
            // Subscription cards
            HStack(spacing: 16) {
                subscriptionCard(
                    isSelected: subscriptionIndex == 0,
                    price: iapManager.subscriptions.isEmpty ? "..." : iapManager.subscriptions[0].displayPrice,
                    period: "Per Year",
                    savings: "Save 40%",
                    action: { subscriptionIndex = 0 }
                )
                
                subscriptionCard(
                    isSelected: subscriptionIndex == 1,
                    price: iapManager.subscriptions.isEmpty ? "..." : iapManager.subscriptions[1].displayPrice,
                    period: "Per Month",
                    savings: nil,
                    action: { subscriptionIndex = 1 }
                )
            }
            
            // Benefits info
            VStack(spacing: 12) {
                Text("✨ Premium Benefits")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                VStack(spacing: 8) {
                    benefitRow(icon: "xmark.circle.fill", text: "No more advertisements")
                    benefitRow(icon: "checkmark.circle.fill", text: "Uninterrupted reading experience")
                    benefitRow(icon: "checkmark.circle.fill", text: "Faster app performance")
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    // MARK: - Benefit Row
    private func benefitRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(icon.contains("checkmark") ? .green : .red)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
    
    // MARK: - Subscription Card
    private func subscriptionCard(
        isSelected: Bool,
        price: String,
        period: String,
        savings: String?,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // Price and period
                VStack(spacing: 8) {
                    Text(price)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(period)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Savings badge
                if let savings = savings {
                    Text(savings)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.orange, Color.red]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }
                
                // Cancel anytime text
                Text("Cancel anytime")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160) // Fixed height for equal cards
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 3)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Continue Button Section
    private var continueButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                Task {
                    if !iapManager.subscriptions.isEmpty {
                        await buy(product: iapManager.subscriptions[subscriptionIndex])
                    }
                }
            }) {
                HStack {
                    if isPurchasing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Subscribe Now")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .foregroundColor(.white)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.orange, Color.red]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .disabled(isPurchasing || iapManager.subscriptions.isEmpty)
            .opacity(iapManager.subscriptions.isEmpty ? 0.6 : 1.0)
            
            // Terms text
            VStack{
                Text("By subscribing, you agree to our ")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack(spacing: 0) {
                   
                    
                    NavigationLink(destination: WebView(urlString: "https://appsved.com/terms-of-use")) {
                        Text("Terms of Service")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .underline()
                    }
                    
                    Text(" and ")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: WebView(urlString: "https://appsved.com/privacy-policy")) {
                        Text("Privacy Policy.")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .underline()
                    }
                }
               
            } .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Purchase Functions
    func buy(product: Product) async {
        guard !isPurchasing else { return }
        isPurchasing = true
        defer { isPurchasing = false }
        
        do {
            if try await iapManager.purchase(product) != nil {
                isPurchased = true
                presentationMode.wrappedValue.dismiss()
            }
        } catch {
            print("purchase failed: \(error)")
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

struct PremiumDescriptionPage_Previews: PreviewProvider {
    static var previews: some View {
        PremiumDescriptionPage()
            .environmentObject(IAPManager())
    }
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
