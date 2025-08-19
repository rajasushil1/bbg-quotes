//
//  TikTokQuotesFeed.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//

import SwiftUI
import UIKit

// MARK: - Model

struct Quote: Identifiable, Hashable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let author: String
}

extension Quote {
    static let samples: [Quote] = Quote.spiritualQuotes
}

// MARK: - Feed

struct TikTokQuotesFeed: View {
    let quotes: [Quote]
    @State private var randomizedQuotes: [Quote] = []
    @State private var usedIndices: Set<Int> = []
    @StateObject private var backgroundThemeViewModel = BackgroundThemeViewModel()
    @StateObject private var musicPlayerViewModel = MusicPlayerViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(Array(randomizedQuotes.enumerated()), id: \.element.id) { index, quote in
                    QuotePage(quote: quote, backgroundThemeViewModel: backgroundThemeViewModel, musicPlayerViewModel: musicPlayerViewModel)
                        .id("\(quote.id)-\(index)")
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .onAppear {
                            // When reaching the end, add more randomized quotes for infinite loop
                            if index >= randomizedQuotes.count - 5 {
                                addMoreRandomizedQuotes()
                            }
                        }
                }
            }
        }
        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
        .background(.black)
        .onAppear {
            if randomizedQuotes.isEmpty {
                initializeRandomizedQuotes()
            }
        }
    }
    
    private func initializeRandomizedQuotes() {
        // Create initial randomized array with all quotes shuffled
        randomizedQuotes = quotes.shuffled()
        usedIndices.removeAll()
    }
    
    private func addMoreRandomizedQuotes() {
        // Create a completely new randomized sequence for infinite loop
        let newRandomizedQuotes = quotes.shuffled()
        randomizedQuotes.append(contentsOf: newRandomizedQuotes)
    }
}

// MARK: - Page

struct QuotePage: View {
    let quote: Quote
    let backgroundThemeViewModel: BackgroundThemeViewModel
    let musicPlayerViewModel: MusicPlayerViewModel
    @State private var likeCount = Int.random(in: 100...9999)
    @State private var musicCount = Int.random(in: 50...500)
    @State private var shareCount = Int.random(in: 10...100)
    @State private var editCount = Int.random(in: 5...50)
    @StateObject private var shareViewModel = QuoteShareViewModel()
    @StateObject private var favoritesManager = FavoritesManager.shared
    @State private var backgroundImage: UIImage?
    @State private var showingThemeSheet = false
    @State private var showingMusicSheet = false

    var body: some View {
        ZStack {
            // Background Image
            Image(backgroundThemeViewModel.currentBackground)
            
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: .infinity)
            .clipped()
            .onAppear {
                // Convert SwiftUI image to UIImage for sharing
                let renderer = ImageRenderer(content: Image(backgroundThemeViewModel.currentBackground))
                renderer.scale = UIScreen.main.scale
                backgroundImage = renderer.uiImage
            }            
            
            VStack(spacing: 20) {
                if !quote.author.isEmpty {
                    Text("— \(quote.author)")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(color: .black, radius: 3, x: 1, y: 1)
                }
                Spacer()
                if !quote.title.isEmpty {
                    Text(quote.title)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3, x: 1, y: 1)
                }

                Text("“\(quote.description)”")
                    .font(.title2)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.95, green: 0.87, blue: 0.65), // Light cream
                                Color(red: 0.92, green: 0.78, blue: 0.55), // Warm beige
                                Color(red: 0.88, green: 0.72, blue: 0.45), // Golden tan
                                Color(red: 0.85, green: 0.68, blue: 0.38)  // Rich amber
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.horizontal, 24)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 1, y: 1)

                
                Spacer()
                
            }
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: .infinity)
            .padding(.top, 60)
            .padding(.horizontal, 20)
            
            // TikTok-style action buttons on the right
            VStack(spacing: 10) {
                Spacer()
                
                // Love button
                VStack(spacing: 8) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            favoritesManager.toggleFavorite(quote)
                            if favoritesManager.isFavorite(quote) {
                                likeCount += 1
                            } else {
                                likeCount -= 1
                            }
                        }
                    }) {
                        Image(systemName: favoritesManager.isFavorite(quote) ? "heart.fill" : "heart")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(favoritesManager.isFavorite(quote) ? .red : .white)
                            .frame(width: 50, height: 50)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                            
                    }
                    .scaleEffect(favoritesManager.isFavorite(quote) ? 1.2 : 1.0)
                    
                    Text("\(likeCount)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                
               
                
                // Share button
                VStack(spacing: 8) {
                    Button(action: {
                        shareViewModel.captureAndShareQuote(quote: quote, backgroundImage: backgroundImage)
                    }) {
                        Image(systemName: "arrowshape.turn.up.right")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .disabled(shareViewModel.isSharing)
                    
                    Text("\(shareCount)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                
                // Theme change button
                VStack(spacing: 8) {
                    Button(action: {
                        showingThemeSheet = true
                    }) {
                        Image(systemName: "paintbrush.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    Text("Theme")
                        .font(.caption)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                
                // Music selection button
                VStack(spacing: 8) {
                    Button(action: {
                        showingMusicSheet = true
                    }) {
                        Image(systemName: "music.note")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    Text("Music")
                        .font(.caption)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                
               
                
               
            }
            .frame(maxWidth: UIScreen.main.bounds.width, alignment: .trailing)
            .padding(.trailing, 10)
            .padding(.bottom, 120)
        }
        .alert("Share Error", isPresented: Binding(
            get: { shareViewModel.shareError != nil },
            set: { if !$0 { shareViewModel.shareError = nil } }
        )) {
            Button("OK") {
                shareViewModel.shareError = nil
            }
        } message: {
            if let error = shareViewModel.shareError {
                Text(error)
            }
        }
        .sheet(isPresented: $showingThemeSheet) {
            ThemeSelectionSheet(backgroundThemeViewModel: backgroundThemeViewModel)
        }
        .sheet(isPresented: $showingMusicSheet) {
            MusicSelectionSheet(musicPlayer: musicPlayerViewModel)
        }
    }
}
