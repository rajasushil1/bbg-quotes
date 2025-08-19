//
//  QuoteShareViewModel.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//

import SwiftUI
import UIKit

@MainActor
class QuoteShareViewModel: ObservableObject {
    @Published var isSharing = false
    @Published var shareError: String?
    
    func captureAndShareQuote(quote: Quote, backgroundImage: UIImage?) {
        Task {
            do {
                let screenshot = try await captureQuoteScreenshot(quote: quote, backgroundImage: backgroundImage)
                await shareScreenshot(screenshot)
            } catch {
                shareError = error.localizedDescription
            }
        }
    }
    
    private func captureQuoteScreenshot(quote: Quote, backgroundImage: UIImage?) async throws -> UIImage {
        // Create a view for screenshot capture
        let screenshotView = QuoteScreenshotView(quote: quote, backgroundImage: backgroundImage)
        
        // Convert SwiftUI view to UIImage
        let renderer = ImageRenderer(content: screenshotView)
        renderer.scale = UIScreen.main.scale
        
        guard let image = renderer.uiImage else {
            throw QuoteShareError.renderingFailed
        }
        
        return image
    }
    
    private func shareScreenshot(_ image: UIImage) async {
        await MainActor.run {
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
            // Present the share sheet
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(activityVC, animated: true)
            }
        }
    }
}

enum QuoteShareError: LocalizedError {
    case renderingFailed
    
    var errorDescription: String? {
        switch self {
        case .renderingFailed:
            return "Failed to create screenshot"
        }
    }
}

// MARK: - Screenshot View

struct QuoteScreenshotView: View {
    let quote: Quote
    let backgroundImage: UIImage?
    
    var body: some View {
        ZStack {
            // Background
            if let backgroundImage = backgroundImage {
                Image(uiImage: backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 600)
                    .clipped()
            } else {
                Color.black
                    .frame(width: 400, height: 600)
            }
            
            // Dark overlay
            Color.black.opacity(0.4)
            
            // Quote content
            VStack(spacing: 30) {
                
                Text("— \(quote.author)")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
                    .shadow(color: .black, radius: 4, x: 2, y: 2)
                    .padding(.top, 24)
                Spacer()
                
                Text(quote.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 4, x: 2, y: 2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Text("\"\(quote.description)\"")
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .shadow(color: .black, radius: 4, x: 2, y: 2)

                
                Spacer()
            }
            .frame(width: 400, height: 600)
        }
        .frame(width: 400, height: 600)
        .background(Color.black)
    }
} 
