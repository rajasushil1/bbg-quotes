import SwiftUI
import GoogleMobileAds

struct ChapterGridView: View {
    @ObservedObject var viewModel: SlokaViewModel
    @State private var selectedChapter: SlokaChapter?
    @State private var clickCount = 0
    @State private var nextAdThreshold = Int.random(in: 2...4)
    @StateObject private var iapManager = IAPManager()
    @State private var pendingChapter: SlokaChapter? // Track chapter waiting for ad dismissal
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange.opacity(0.1), Color.yellow.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView("Loading Chapters...")
                        .scaleEffect(1.2)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        Text("Error")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            viewModel.loadSlokas()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.chapters) { chapter in
                                ChapterCardView(chapter: chapter) {
                                    handleChapterTap(chapter)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Bhagavad Gita")
            .navigationBarTitleDisplayMode(.large)
            .fullScreenCover(item: $selectedChapter) { chapter in
                ChapterDetailView(chapter: chapter)
            }
            .onAppear {
                // Load initial interstitial ad
                AdsManager.shared.loadInterstitial()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func handleChapterTap(_ chapter: SlokaChapter) {
        // Increment click count
        clickCount += 1
        
        // Check if it's time to show an ad
        if clickCount >= nextAdThreshold {
            // Store the chapter and show ad, but don't navigate yet
            pendingChapter = chapter
            showInterstitialAd()
            // Reset for next random threshold
            nextAdThreshold = Int.random(in: 2...4)
            clickCount = 0
        } else {
            // No ad needed, navigate directly
            selectedChapter = chapter
        }
    }
    
    private func showInterstitialAd() {
        // Only show ads if user is not premium
        guard !iapManager.purchasedSubscriptions.isEmpty == false else {
            print("Premium user - skipping interstitial ad")
            // If premium user, navigate directly
            if let chapter = pendingChapter {
                selectedChapter = chapter
                pendingChapter = nil
            }
            return
        }
        
        // Get the root view controller to present the interstitial
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            
            // Set up the ad dismissal callback
            AdsManager.shared.setAdDismissalCallback { [self] in
                // This closure will be called when the ad is dismissed
                DispatchQueue.main.async {
                    if let chapter = self.pendingChapter {
                        self.selectedChapter = chapter
                        self.pendingChapter = nil
                    }
                }
            }
            
            AdsManager.shared.showInterstitial(from: rootViewController)
            
            // Preload next interstitial ad
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                AdsManager.shared.loadInterstitial()
            }
        }
    }
}

struct ChapterCardView: View {
    let chapter: SlokaChapter
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.orange, Color.red]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 60, height: 60)
                    
                    Text("\(chapter.id)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 4) {
                    Text(chapter.chapterTitle)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("\(chapter.slokaCount) Slokas")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ChapterGridView(viewModel: SlokaViewModel())
}
