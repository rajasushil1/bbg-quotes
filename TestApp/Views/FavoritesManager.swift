//
//  FavoritesManager.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//

import Foundation
import SwiftUI

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published var favoriteQuotes: [Quote] = []
    
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "FavoriteQuotes"
    
    private init() {
        loadFavorites()
    }
    
    func toggleFavorite(_ quote: Quote) {
        if isFavorite(quote) {
            removeFavorite(quote)
        } else {
            addFavorite(quote)
        }
    }
    
    func addFavorite(_ quote: Quote) {
        if !isFavorite(quote) {
            favoriteQuotes.append(quote)
            saveFavorites()
        }
    }
    
    func removeFavorite(_ quote: Quote) {
        favoriteQuotes.removeAll { $0.id == quote.id }
        saveFavorites()
    }
    
    func isFavorite(_ quote: Quote) -> Bool {
        return favoriteQuotes.contains { $0.id == quote.id }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteQuotes) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([Quote].self, from: data) {
            favoriteQuotes = decoded
        }
    }
}
