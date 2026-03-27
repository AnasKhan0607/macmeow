import Foundation
import Combine

/// Protocol that all personality modules must conform to
protocol Personality: AnyObject {
    /// Unique identifier for the personality
    var id: String { get }
    
    /// Display name
    var name: String { get }
    
    /// Emoji icon
    var icon: String { get }
    
    /// Description of what this personality does
    var description: String { get }
    
    /// Whether this personality is currently enabled
    var isEnabled: Bool { get set }
    
    /// Start reacting to events
    func activate()
    
    /// Stop reacting to events
    func deactivate()
}

/// Base class with common functionality
class BasePersonality: Personality {
    let id: String
    let name: String
    let icon: String
    let description: String
    
    var isEnabled: Bool = false {
        didSet {
            if isEnabled {
                activate()
            } else {
                deactivate()
            }
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    let eventBus = EventBus.shared
    let soundManager = SoundManager.shared
    
    init(id: String, name: String, icon: String, description: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.description = description
    }
    
    func activate() {
        // Override in subclass
    }
    
    func deactivate() {
        cancellables.removeAll()
    }
    
    /// Play a sound from this personality's sound pack
    func playSound(_ sound: String) {
        soundManager.play(sound, from: id)
    }
    
    /// Play a random sound from this personality's sound pack
    func playRandomSound(_ sounds: [String]) {
        soundManager.playRandom(sounds, from: id)
    }
}
