import AVFoundation
import Foundation

/// Manages audio playback for personality reactions
final class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var volume: Float = 0.7
    
    private init() {}
    
    // MARK: - Public API
    
    /// Play a sound from the specified personality's sound pack
    func play(_ sound: String, from personality: String) {
        let soundPath = "Sounds/\(personality)/\(sound)"
        
        guard let url = Bundle.main.url(forResource: soundPath, withExtension: "mp3") else {
            print("⚠️ Sound not found: \(soundPath)")
            return
        }
        
        play(url: url)
    }
    
    /// Play a random sound from a list
    func playRandom(_ sounds: [String], from personality: String) {
        guard let sound = sounds.randomElement() else { return }
        play(sound, from: personality)
    }
    
    /// Play sound from URL
    func play(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = volume
            audioPlayer?.play()
        } catch {
            print("❌ Failed to play sound: \(error)")
        }
    }
    
    /// Stop any currently playing sound
    func stop() {
        audioPlayer?.stop()
    }
    
    /// Set volume (0.0 - 1.0)
    func setVolume(_ newVolume: Float) {
        volume = max(0, min(1, newVolume))
        audioPlayer?.volume = volume
    }
    
    /// Check if currently playing
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
}
