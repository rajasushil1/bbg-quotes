//
//  IAPManager.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 27/08/2025.
//

import Foundation
import StoreKit

// alias
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

class IAPManager: ObservableObject {
    @Published private(set) var subscriptions: [Product] = []
    @Published private(set) var purchasedSubscriptions: [Product] = []
    @Published private(set) var subscriptionGroupStatus: RenewalState?
    
    private let productIds: [String] = ["com.appsved.geeta.and.quotes.monthly", "com.appsved.geeta.and.quotes.yearly"]
    
    var updateListenerTask: Task<Void, Error>? = nil

    init() {
        // Start a transaction listener as close to app launch as possible so you don't miss a transaction
        updateListenerTask = listenForTransactions()
        
        Task {
            await requestProducts()
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    // Deliver products to the user
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    print("transaction failed verification")
                }
            }
        }
    }
    
    // Request the products
    @MainActor
    func requestProducts() async {
        do {
            // Request from the app store using the product ids (hardcoded)
            subscriptions = try await Product.products(for: productIds)
            // Sort products by price in descending order
            subscriptions.sort(by: { $0.price > $1.price })
        } catch {
            print("Failed product request from app store server: \(error)")
        }
    }
    
    // Purchase the product
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            // Check whether the transaction is verified. If it isn't, this function rethrows the verification error.
            let transaction = try checkVerified(verification)
            // The transaction is verified. Deliver content to the user.
            await updateCustomerProductStatus()
            // Always finish a transaction.
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            // StoreKit parses the JWS, but it fails verification.
            throw StoreError.failedVerification
        case .verified(let safe):
            // The result is verified. Return the unwrapped value.
            return safe
        }
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                // Check whether the transaction is verified. If it isn’t, catch `failedVerification` error.
                let transaction = try checkVerified(result)
                
                switch transaction.productType {
                case .autoRenewable:
                    if let subscription = subscriptions.first(where: { $0.id == transaction.productID }) {
                        purchasedSubscriptions.append(subscription)
                    }
                default:
                    break
                }
                // Always finish a transaction.
                await transaction.finish()
            } catch {
                print("failed updating products")
            }
        }
    }
    
    func isPurchased(_ product: Product) -> Bool {
        return purchasedSubscriptions.contains(product)
    }
    
    func refreshPurchasedProducts() async {
        // Iterate through the user's purchased products.
        for await verificationResult in Transaction.currentEntitlements {
            switch verificationResult {
            case .verified(_):
                break
            // Check the type of product for the transaction // and provide access to the content as appropriate. ...
            case .unverified(_, _):
                break
            // Handle unverified transactions based on your // business model. ...
            }
        }
    }
}

public enum StoreError: Error {
    case failedVerification
}

enum SubscriptionType {
    case monthly, yearly
}

