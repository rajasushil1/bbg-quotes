//
//  SettingsPage.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//

import SwiftUI

struct SettingsPage: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        NavigationView {
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
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
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
