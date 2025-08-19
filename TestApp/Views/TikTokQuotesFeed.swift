//
//  TikTokQuotesFeed.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//

import SwiftUI

// MARK: - Model

struct Quote: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let author: String
}

extension Quote {
    static let samples: [Quote] = [
        .init(title: "Fear Itself",
              description: "The only thing we have to fear is fear itself.",
              author: "Franklin D. Roosevelt"),
        .init(title: "Stay Hungry",
              description: "Stay hungry, stay foolish.",
              author: "Steve Jobs"),
        .init(title: "Opportunity",
              description: "In the middle of difficulty lies opportunity.",
              author: "Albert Einstein"),
        .init(title: "Actions Speak",
              description: "What you do speaks so loudly that I cannot hear what you say.",
              author: "Ralph Waldo Emerson"),
        .init(title: "Excellence",
              description: "We are what we repeatedly do. Excellence, then, is not an act but a habit.",
              author: "Will Durant"),
        .init(title: "Impossible Done",
              description: "It always seems impossible until it’s done.",
              author: "Nelson Mandela")
    ]
}

// MARK: - Feed

struct TikTokQuotesFeed: View {
    let quotes: [Quote]

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(quotes) { quote in
                    QuotePage(quote: quote)
                        .id(quote.id)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
            }
        }
        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
        .background(.black)
    }
}

// MARK: - Page

struct QuotePage: View {
    let quote: Quote
    @State private var isLiked = false
    @State private var likeCount = Int.random(in: 100...9999)
    @State private var musicCount = Int.random(in: 50...500)
    @State private var shareCount = Int.random(in: 10...100)
    @State private var editCount = Int.random(in: 5...50)

    var body: some View {
        ZStack {
            // Background Image
            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&h=2000&fit=crop&crop=center")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: .infinity)
                    .clipped()
            } placeholder: {
                Color.black
            }
            
            // Dark overlay for better text readability
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("— \(quote.author)")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
                    .shadow(color: .black, radius: 3, x: 1, y: 1)
                Spacer()
                Text(quote.title)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 3, x: 1, y: 1)

                Text("“\(quote.description)”")
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .shadow(color: .black, radius: 3, x: 1, y: 1)

                
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
                            isLiked.toggle()
                            if isLiked {
                                likeCount += 1
                            } else {
                                likeCount -= 1
                            }
                        }
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(isLiked ? .red : .white)
                            .frame(width: 50, height: 50)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                            
                    }
                    .scaleEffect(isLiked ? 1.2 : 1.0)
                    
                    Text("\(likeCount)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                
               
                
                // Share button
                VStack(spacing: 8) {
                    Button(action: {
                        // Share action
                    }) {
                        Image(systemName: "arrowshape.turn.up.right")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    Text("\(shareCount)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                
               
                
               
            }
            .frame(maxWidth: UIScreen.main.bounds.width, alignment: .trailing)
            .padding(.trailing, 10)
            .padding(.bottom, 120)
        }
    }
}
