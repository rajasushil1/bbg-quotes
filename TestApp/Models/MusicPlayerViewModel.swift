//
//  MusicPlayerViewModel.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//

import Foundation
import AVFoundation
import SwiftUI

class MusicPlayerViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var currentMusic: String = "None"
    @Published var volume: Float = 0.5
    @Published var isMuted = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var isLoading = false
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    let musicOptions = [
        "None": "",
        "Calm Ambient": "1",
        "Upbeat Pop": "2",
        "Classical Piano": "3",
        "Lo-fi Beats": "4",
        "Nature Sounds": "5",
        "Jazz Vibes": "6",
        "Electronic Dance": "7",
        "Acoustic Guitar": "8",
        "Chill Hop": "9"
    ]
    
    init() {
        setupAudioSession()
        setupTimer()
        setupNotifications()
    }
    
    deinit {
        stopMusic()
        timer?.invalidate()
        removeNotifications()
    }
    
    // MARK: - Audio Session Setup
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioSessionInterruption),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRouteChange),
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleAudioSessionInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            // Audio session interrupted, pause playback
            if isPlaying {
                pauseMusic()
            }
        case .ended:
            // Audio session interruption ended, resume if appropriate
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    playMusic()
                }
            }
        @unknown default:
            break
        }
    }
    
    @objc private func handleRouteChange(notification: Notification) {
        // Handle audio route changes (e.g., headphones connected/disconnected)
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        
        switch reason {
        case .newDeviceAvailable, .oldDeviceUnavailable:
            // Audio device changed, update audio session
            setupAudioSession()
        default:
            break
        }
    }
    
    // MARK: - Timer Setup
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            
            if player.isPlaying {
                self.currentTime = player.currentTime
                self.duration = player.duration
            }
        }
    }
    
    // MARK: - Music Control
    
    func selectMusic(_ musicName: String) {
        // If the same music is selected, toggle it off
        if currentMusic == musicName {
            stopMusic()
            currentMusic = "None"
            return
        }
        
        // Otherwise, select the new music
        stopMusic()
        currentMusic = musicName
        
        if musicName != "None" {
            loadAndPlayMusic(musicName)
        }
    }
    
    private func loadAndPlayMusic(_ musicName: String) {
        isLoading = true
        
        // Try to load actual audio file first
        if let audioPlayer = loadAudioFile(for: musicName) {
            self.audioPlayer = audioPlayer
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.volume = isMuted ? 0 : volume
            self.audioPlayer?.numberOfLoops = -1
            self.isLoading = false
            self.playMusic()
        } else {
            // Fallback to generated audio
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isLoading = false
                self.createSilentPlayer()
                self.playMusic()
            }
        }
    }
    
    private func loadAudioFile(for musicName: String) -> AVAudioPlayer? {
        // In a real app, you would have actual audio files in your bundle
        // For now, we'll return nil to use the fallback
        guard let filename = musicOptions[musicName], !filename.isEmpty else {
            print("No filename found for music: \(musicName)")
            return nil
        }
        
        print("Attempting to load audio file: \(filename).mp3")
        
        // Try to load the actual audio file from the bundle
        if let url = Bundle.main.url(forResource: filename, withExtension: "mp3") {
            print("Found audio file at URL: \(url)")
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                print("Successfully loaded audio file: \(filename).mp3")
                return player
            } catch {
                print("Failed to load audio file \(filename).mp3: \(error)")
                return nil
            }
        } else {
            print("Audio file not found in bundle: \(filename).mp3")
            
            // Debug: List all resources in bundle
            if let resourcePath = Bundle.main.resourcePath {
                do {
                    let items = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                    print("Bundle contents: \(items)")
                } catch {
                    print("Could not list bundle contents: \(error)")
                }
            }
            
            return nil
        }
    }
    
    func playMusic() {
        guard currentMusic != "None" else { return }
        
        if audioPlayer == nil {
            // Create a silent audio player for demonstration
            // In a real app, you would load the actual audio file
            createSilentPlayer()
        }
        
        audioPlayer?.play()
        isPlaying = true
    }
    
    func pauseMusic() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func stopMusic() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        currentTime = 0
        duration = 0
    }
    
    func togglePlayPause() {
        if isPlaying {
            pauseMusic()
        } else {
            playMusic()
        }
    }
    
    // MARK: - Volume Control
    
    func setVolume(_ newVolume: Float) {
        volume = max(0, min(1, newVolume))
        audioPlayer?.volume = isMuted ? 0 : volume
    }
    
    func toggleMute() {
        isMuted.toggle()
        audioPlayer?.volume = isMuted ? 0 : volume
    }
    
    // MARK: - Seek Control
    
    func seekTo(_ time: TimeInterval) {
        guard let player = audioPlayer else { return }
        
        let clampedTime = max(0, min(time, player.duration))
        player.currentTime = clampedTime
        currentTime = clampedTime
    }
    
    func seekForward() {
        let newTime = currentTime + 10
        seekTo(newTime)
    }
    
    func seekBackward() {
        let newTime = currentTime - 10
        seekTo(newTime)
    }
    
    // MARK: - Helper Methods
    
    private func createSilentPlayer() {
        // Create a silent audio player for demonstration purposes
        // In a real app, you would load actual audio files from your bundle
        do {
            // Create a simple sine wave tone instead of empty data
            let sampleRate: Double = 44100
            let duration: Double = 60 // 1 minute
            let frequency: Double = 440 // A4 note
            
            let frameCount = Int(sampleRate * duration)
            var audioData = Data()
            
            // Generate a simple sine wave with proper 16-bit PCM format
            for i in 0..<frameCount {
                let sample = sin(2.0 * Double.pi * frequency * Double(i) / sampleRate)
                let intSample = Int16(sample * 16383.0 * 0.01) // Reduce volume to 1%
                
                // Convert to little-endian bytes (16-bit PCM)
                let bytes = withUnsafeBytes(of: intSample.littleEndian) { Data($0) }
                audioData.append(bytes)
            }
            
            // Create audio player with proper format settings
            let audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = isMuted ? 0 : volume
            audioPlayer.numberOfLoops = -1 // Loop indefinitely
            
            self.audioPlayer = audioPlayer
            print("Successfully created generated audio player")
            
        } catch {
            print("Failed to create audio player: \(error)")
            // Fallback: create a player with a simple beep sound
            createFallbackPlayer()
        }
    }
    
    private func createFallbackPlayer() {
        // Create a very simple fallback player
        do {
            let sampleRate: Double = 44100
            let duration: Double = 1 // 1 second
            
            let frameCount = Int(sampleRate * duration)
            var audioData = Data()
            
            // Generate a simple beep with proper 16-bit PCM format
            for i in 0..<frameCount {
                let sample = sin(2.0 * Double.pi * 800.0 * Double(i) / sampleRate)
                let intSample = Int16(sample * 16383.0 * 0.005) // Very quiet
                
                let bytes = withUnsafeBytes(of: intSample.littleEndian) { Data($0) }
                audioData.append(bytes)
            }
            
            let audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 0 // Start silent
            audioPlayer.numberOfLoops = -1
            
            self.audioPlayer = audioPlayer
            print("Successfully created fallback audio player")
            
        } catch {
            print("Failed to create fallback audio player: \(error)")
            // If all else fails, just set up the player without audio
            setupDummyPlayer()
        }
    }
    
    private func setupDummyPlayer() {
        // Create a dummy player that doesn't actually play audio
        // This allows the UI to work without crashing
        class DummyAudioPlayer: NSObject {
            var isPlaying: Bool = false
            var currentTime: TimeInterval = 0
            var duration: TimeInterval = 60
            var volume: Float = 0.5
            var numberOfLoops: Int = -1
            
            func play() { isPlaying = true }
            func pause() { isPlaying = false }
            func stop() { isPlaying = false; currentTime = 0 }
            func prepareToPlay() {}
        }
        
        // Use a dummy player that won't crash
        let dummyPlayer = DummyAudioPlayer()
        
        // Create a wrapper that conforms to AVAudioPlayer protocol
        // This is a workaround for demonstration purposes
        // In a real app, you would load actual audio files
        print("Using dummy audio player - no actual audio will play")
        
        // Set up timer to simulate playback
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if dummyPlayer.isPlaying {
                self.currentTime = dummyPlayer.currentTime
                self.duration = dummyPlayer.duration
                dummyPlayer.currentTime += 0.1
            }
        }
    }
    
    // MARK: - Formatting
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func formatProgress() -> Double {
        guard duration > 0 else { return 0 }
        return currentTime / duration
    }
}
