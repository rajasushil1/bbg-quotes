import SwiftUI

struct ChapterDetailView: View {
    let chapter: SlokaChapter
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSlokaIndex = 0
    
    // Safety check to ensure we don't access invalid indices
    private var currentSloka: String {
        guard selectedSlokaIndex < chapter.sloka.count else { return "Sloka not available" }
        return chapter.sloka[selectedSlokaIndex]
    }
    
    private var currentExplanation: String {
        guard selectedSlokaIndex < chapter.explanation.count else { return "Explanation not available" }
        return chapter.explanation[selectedSlokaIndex]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                
                VStack(spacing: 0) {
                    chapterHeader
                    
                    if chapter.slokaCount > 1 {
                        slokaSelector
                    }
                    
                    slokaContent
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                leadingToolbarItem
                trailingToolbarItem
            }
        }
    }
    
    // MARK: - Background
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.orange.opacity(0.1), Color.yellow.opacity(0.1)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Chapter Header
    private var chapterHeader: some View {
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
            
            VStack(spacing: 8) {
                Text(chapter.chapterTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("\(chapter.slokaCount) Slokas")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
        .padding(.top, -30)
    }
    
    // MARK: - Sloka Selector
    private var slokaSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<chapter.slokaCount, id: \.self) { index in
                    SlokaSelectorButton(
                        index: index,
                        isSelected: selectedSlokaIndex == index,
                        action: { selectedSlokaIndex = index }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .padding(.vertical,8)
    }
    
    // MARK: - Sloka Content
    private var slokaContent: some View {
        ScrollView {
            VStack(spacing: 12) {
                slokaTextSection
                explanationSection
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Sloka Text Section
    private var slokaTextSection: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack {
                Image(systemName: "text.quote")
                    .foregroundColor(.orange)
                    .font(.title2)
                
                Text("Sloka \(selectedSlokaIndex + 1)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            Text(currentSloka)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding()
                .frame(width:UIScreen.main.bounds.width * 0.9)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
        }
    }
    
    // MARK: - Explanation Section
    private var explanationSection: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
                
                Text("Explanation")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            VStack{
                Text(currentExplanation)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(width:UIScreen.main.bounds.width * 0.9)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    )
            }
        }
    }
    
    // MARK: - Toolbar Items
    private var leadingToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.orange)
            }
        }
    }
    
    private var trailingToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if chapter.slokaCount > 1 {
                HStack(spacing: 16) {
                    Button(action: {
                        if selectedSlokaIndex > 0 {
                            selectedSlokaIndex -= 1
                        }
                    }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.title2)
                            .foregroundColor(selectedSlokaIndex > 0 ? .orange : .gray)
                    }
                    .disabled(selectedSlokaIndex == 0)
                    
                    Button(action: {
                        if selectedSlokaIndex < chapter.slokaCount - 1 {
                            selectedSlokaIndex += 1
                        }
                    }) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.title2)
                            .foregroundColor(selectedSlokaIndex < chapter.slokaCount - 1 ? .orange : .gray)
                    }
                    .disabled(selectedSlokaIndex == chapter.slokaCount - 1)
                }
            }
        }
    }
}

// MARK: - Sloka Selector Button
struct SlokaSelectorButton: View {
    let index: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(index + 1)")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(
                            isSelected
                            ? AnyShapeStyle(
                                LinearGradient(
                                    colors: [Color.orange, Color.red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                              )
                            : AnyShapeStyle(Color.white)
                        )
                )

                .overlay(
                    Circle()
                        .stroke(Color.orange.opacity(0.3), lineWidth: 2)
                )
        }
    }
}

#Preview {
    let sampleChapter = SlokaChapter(
        id: 1,
        sloka: ["Sample sloka text here"],
        explanation: ["Sample explanation text here"]
    )
    ChapterDetailView(chapter: sampleChapter)
}
