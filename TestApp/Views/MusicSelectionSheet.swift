//
//  MusicSelectionSheet.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//

import SwiftUI

struct MusicSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var musicPlayer: MusicPlayerViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient - Light theme
                LinearGradient(
                    colors: [Color.white, Color(red: 0.95, green: 0.97, blue: 1.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Music Categories Grid
                        LazyVStack(spacing: 16) {
                            // No Music Option
                            SpotifyStyleMusicCard(
                                musicName: "No Music",
                                isSelected: musicPlayer.currentMusic == "None",
                                isPlaying: false,
                                onTap: {
                                    musicPlayer.selectMusic("None")
                                }
                            )
                            
                            ForEach(Array(musicPlayer.musicOptions.keys.sorted()), id: \.self) { music in
                                if music != "None" {
                                    SpotifyStyleMusicCard(
                                        musicName: music,
                                        isSelected: musicPlayer.currentMusic == music,
                                        isPlaying: musicPlayer.isPlaying && musicPlayer.currentMusic == music,
                                        onTap: {
                                            musicPlayer.selectMusic(music)
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }.padding(.top, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Choose Your Vibe")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .font(.system(size: 16, weight: .medium))
                }
            }
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

// MARK: - Spotify Style Music Card

struct SpotifyStyleMusicCard: View {
    let musicName: String
    let isSelected: Bool
    let isPlaying: Bool
    let onTap: () -> Void
    
    // Music category colors and icons
    private var musicStyle: (color: Color, icon: String, gradient: [Color]) {
        switch musicName {
        case "No Music":
            return (.gray, "speaker.slash.fill", [Color.gray.opacity(0.6), Color.gray.opacity(0.4)])
        case "Calm Ambient":
            return (.blue, "cloud.fill", [Color.blue.opacity(0.8), Color.blue.opacity(0.6)])
        case "Upbeat Pop":
            return (.pink, "heart.fill", [Color.pink.opacity(0.8), Color.pink.opacity(0.6)])
        case "Classical Piano":
            return (.brown, "pianokeys", [Color.brown.opacity(0.8), Color.brown.opacity(0.6)])
        case "Lo-fi Beats":
            return (.purple, "waveform", [Color.purple.opacity(0.8), Color.purple.opacity(0.6)])
        case "Nature Sounds":
            return (.green, "leaf.fill", [Color.green.opacity(0.8), Color.green.opacity(0.6)])
        case "Jazz Vibes":
            return (.orange, "music.note.list", [Color.orange.opacity(0.8), Color.orange.opacity(0.6)])
        case "Electronic Dance":
            return (.cyan, "bolt.fill", [Color.cyan.opacity(0.8), Color.cyan.opacity(0.6)])
        case "Acoustic Guitar":
            return (.mint, "guitars", [Color.mint.opacity(0.8), Color.mint.opacity(0.6)])
        case "Chill Hop":
            return (.indigo, "headphones", [Color.indigo.opacity(0.8), Color.indigo.opacity(0.6)])
        default:
            return (.gray, "music.note", [Color.gray.opacity(0.8), Color.gray.opacity(0.6)])
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Music Icon with gradient background
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: musicStyle.gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: musicStyle.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                // Music Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(musicName)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    
                    Text(getMusicDescription(musicName))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black.opacity(0.7))
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Play/Select indicator
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 32, height: 32)
                        
                        if isPlaying {
                            Image(systemName: "pause.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "play.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                    } else {
                        Circle()
                            .stroke(Color.black.opacity(0.3), lineWidth: 2)
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "play.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black.opacity(0.7))
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? Color.green.opacity(0.8) : Color.gray.opacity(0.2),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
                    .shadow(
                        color: isSelected ? Color.green.opacity(0.3) : Color.black.opacity(0.1),
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
    
    private func getMusicDescription(_ musicName: String) -> String {
        switch musicName {
        case "No Music": return "Silence - no background music"
        case "Calm Ambient": return "Peaceful atmospheric sounds"
        case "Upbeat Pop": return "Energetic and uplifting"
        case "Classical Piano": return "Elegant piano melodies"
        case "Lo-fi Beats": return "Chill hip-hop vibes"
        case "Nature Sounds": return "Forest and ocean ambience"
        case "Jazz Vibes": return "Smooth jazz grooves"
        case "Electronic Dance": return "High-energy electronic"
        case "Acoustic Guitar": return "Warm acoustic melodies"
        case "Chill Hop": return "Relaxed hip-hop beats"
        default: return "Background music"
        }
    }
}

#Preview {
    MusicSelectionSheet(musicPlayer: MusicPlayerViewModel())
}
