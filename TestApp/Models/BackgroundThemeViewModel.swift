import SwiftUI

class BackgroundThemeViewModel: ObservableObject {
    @Published var currentBackgroundIndex: Int = 0
    @Published var showingThemeSheet: Bool = false
    
    let backgroundImages = [
        "Bg2", "Bg6","Bg1", "Bg10","Bg3","Bg9",  "Bg5",
         "Bg8",   "Bg11","Bg7", "Bg12"
    ]
    
    var currentBackground: String {
        backgroundImages[currentBackgroundIndex]
    }
    
    func nextBackground() {
        currentBackgroundIndex = (currentBackgroundIndex + 1) % backgroundImages.count
    }
    
    func previousBackground() {
        currentBackgroundIndex = currentBackgroundIndex == 0 ? backgroundImages.count - 1 : currentBackgroundIndex - 1
    }
    
    func setBackground(_ index: Int) {
        guard index >= 0 && index < backgroundImages.count else { return }
        currentBackgroundIndex = index
    }
    
    func randomBackground() {
        currentBackgroundIndex = Int.random(in: 0..<backgroundImages.count)
    }
    
    func showThemeSheet() {
        showingThemeSheet = true
    }
}
