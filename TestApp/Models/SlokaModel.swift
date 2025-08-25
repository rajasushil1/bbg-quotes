import Foundation

struct SlokaChapter: Codable, Identifiable {
    let id: Int
    let sloka: [String]
    let explanation: [String]
    
    var chapterTitle: String {
        return "Chapter \(id)"
    }
    
    var slokaCount: Int {
        return sloka.count
    }
}

struct SlokaData: Codable {
    let chapters: [SlokaChapter]
}
