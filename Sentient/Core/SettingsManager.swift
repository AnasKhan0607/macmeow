import Foundation
import Combine

/// Manages app settings with UserDefaults persistence
final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Settings Keys
    
    private enum Keys {
        static let volume = "volume"
        static let launchAtLogin = "launchAtLogin"
        static let dramaticEnabled = "personality.dramatic.enabled"
        static let hungryEnabled = "personality.hungry.enabled"
        static let judgmentalEnabled = "personality.judgmental.enabled"
        static let needyEnabled = "personality.needy.enabled"
        static let sleepyEnabled = "personality.sleepy.enabled"
        static let chaoticEnabled = "personality.chaotic.enabled"
        static let guiltyApps = "judgmental.guiltyApps"
    }
    
    // MARK: - Published Properties
    
    @Published var volume: Float {
        didSet { defaults.set(volume, forKey: Keys.volume) }
    }
    
    @Published var launchAtLogin: Bool {
        didSet { defaults.set(launchAtLogin, forKey: Keys.launchAtLogin) }
    }
    
    @Published var dramaticEnabled: Bool {
        didSet { defaults.set(dramaticEnabled, forKey: Keys.dramaticEnabled) }
    }
    
    @Published var hungryEnabled: Bool {
        didSet { defaults.set(hungryEnabled, forKey: Keys.hungryEnabled) }
    }
    
    @Published var judgmentalEnabled: Bool {
        didSet { defaults.set(judgmentalEnabled, forKey: Keys.judgmentalEnabled) }
    }
    
    @Published var needyEnabled: Bool {
        didSet { defaults.set(needyEnabled, forKey: Keys.needyEnabled) }
    }
    
    @Published var sleepyEnabled: Bool {
        didSet { defaults.set(sleepyEnabled, forKey: Keys.sleepyEnabled) }
    }
    
    @Published var chaoticEnabled: Bool {
        didSet { defaults.set(chaoticEnabled, forKey: Keys.chaoticEnabled) }
    }
    
    @Published var guiltyApps: [String] {
        didSet { defaults.set(guiltyApps, forKey: Keys.guiltyApps) }
    }
    
    // MARK: - Initialization
    
    private init() {
        // Load from UserDefaults with defaults
        volume = defaults.float(forKey: Keys.volume)
        if volume == 0 { volume = 0.7 }
        
        launchAtLogin = defaults.bool(forKey: Keys.launchAtLogin)
        
        // Default personalities enabled
        dramaticEnabled = defaults.object(forKey: Keys.dramaticEnabled) as? Bool ?? true
        hungryEnabled = defaults.object(forKey: Keys.hungryEnabled) as? Bool ?? true
        judgmentalEnabled = defaults.object(forKey: Keys.judgmentalEnabled) as? Bool ?? false
        needyEnabled = defaults.object(forKey: Keys.needyEnabled) as? Bool ?? false
        sleepyEnabled = defaults.object(forKey: Keys.sleepyEnabled) as? Bool ?? false
        chaoticEnabled = defaults.object(forKey: Keys.chaoticEnabled) as? Bool ?? false
        
        // Default guilty pleasure apps
        guiltyApps = defaults.stringArray(forKey: Keys.guiltyApps) ?? [
            "Twitter",
            "Reddit", 
            "TikTok",
            "Instagram",
            "YouTube",
            "Netflix"
        ]
    }
}
