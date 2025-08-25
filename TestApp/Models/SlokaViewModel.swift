import Foundation
import SwiftUI

class SlokaViewModel: ObservableObject {
    @Published var chapters: [SlokaChapter] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        loadSlokas()
    }
    
    func loadSlokas() {
        isLoading = true
        errorMessage = nil
        
        print("🔍 Attempting to load slokas from Bundle...")
        
        guard let url = Bundle.main.url(forResource: "slokas_nepali", withExtension: "json") else {
            let error = "Could not find slokas_nepali.json in Bundle"
            print("❌ Error: \(error)")
            errorMessage = error
            isLoading = false
            return
        }
        
        print("✅ Found JSON file at: \(url)")
        
        do {
            let data = try Data(contentsOf: url)
            print("📊 Loaded \(data.count) bytes of JSON data")
            
            let decoder = JSONDecoder()
            chapters = try decoder.decode([SlokaChapter].self, from: data)
            
            print("🎯 Successfully decoded \(chapters.count) chapters")
            for (index, chapter) in chapters.enumerated() {
                print("   Chapter \(chapter.id): \(chapter.sloka.count) slokas, \(chapter.explanation.count) explanations")
            }
            
            isLoading = false
        } catch {
            let error = "Failed to load slokas: \(error.localizedDescription)"
            print("❌ Decoding error: \(error)")
            print("🔍 Error details: \(error)")
            errorMessage = error
            isLoading = false
        }
    }
}
