import SwiftUI

struct ThemeSelectionSheet: View {
    @ObservedObject var backgroundThemeViewModel: BackgroundThemeViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
       
            VStack() {
                // Header
                HStack {
                    Text("Choose Theme")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Grid of background images
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(Array(backgroundThemeViewModel.backgroundImages.enumerated()), id: \.offset) { index, imageName in
                            ThemeImageCell(
                                imageName: imageName,
                                isSelected: index == backgroundThemeViewModel.currentBackgroundIndex,
                                onTap: {
                                    backgroundThemeViewModel.setBackground(index)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
                
                Spacer()
            }
        .background(Color(.systemBackground))
        .presentationDetents([.large, .large])
        .presentationDragIndicator(.hidden)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ThemeImageCell: View {
    let imageName: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Background image with 9:16 aspect ratio
                Image(imageName)
                    .resizable()
                    .aspectRatio(9/16, contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)
                
                // Selection indicator
                if isSelected {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 3)
                        .frame(height: 200)
                    
                    // Checkmark overlay
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(8)
                }
            }
        }
        .padding(.top, 10)
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    ThemeSelectionSheet(backgroundThemeViewModel: BackgroundThemeViewModel())
}
