import Foundation
import Combine

/// Judgmental personality - judges you when you open certain apps
final class JudgmentalPersonality: BasePersonality {
    
    private var lastJudgmentTime: Date = .distantPast
    private let cooldownDuration: TimeInterval = 30  // Seconds between judgments
    private var settings = SettingsManager.shared
    
    // App severity levels (higher = more judgy)
    private let appSeverity: [String: Int] = [
        "TikTok": 3,
        "Twitter": 2,
        "X": 2,
        "Reddit": 2,
        "Instagram": 2,
        "Facebook": 2,
        "YouTube": 1,
        "Netflix": 1,
        "Twitch": 1,
        "Discord": 1,
    ]
    
    init() {
        super.init(
            id: "judgmental",
            name: "Judgmental",
            icon: "😤",
            description: "Judges your app choices with disappointed sighs"
        )
    }
    
    override func activate() {
        print("😤 Judgmental personality activated")
        
        // Listen for app launches
        eventBus.appLaunched
            .sink { [weak self] appName in
                self?.handleAppLaunch(appName)
            }
            .store(in: &cancellables)
    }
    
    override func deactivate() {
        super.deactivate()
        print("😤 Judgmental personality deactivated")
    }
    
    // MARK: - Event Handlers
    
    private func handleAppLaunch(_ appName: String) {
        // Check if this is a guilty app
        guard isGuiltyApp(appName) else { return }
        
        // Check cooldown
        let now = Date()
        guard now.timeIntervalSince(lastJudgmentTime) >= cooldownDuration else {
            return
        }
        
        // Get severity for this app
        let severity = getSeverity(for: appName)
        
        // Judge!
        judge(appName: appName, severity: severity)
        lastJudgmentTime = now
    }
    
    private func isGuiltyApp(_ appName: String) -> Bool {
        // Check against user's configured guilty apps
        return settings.guiltyApps.contains { guilty in
            appName.localizedCaseInsensitiveContains(guilty) ||
            guilty.localizedCaseInsensitiveContains(appName)
        }
    }
    
    private func getSeverity(for appName: String) -> Int {
        // Check predefined severity, default to 1
        for (app, severity) in appSeverity {
            if appName.localizedCaseInsensitiveContains(app) {
                return severity
            }
        }
        return 1
    }
    
    private func judge(appName: String, severity: Int) {
        print("😤 Judging: \(appName) (severity: \(severity))")
        
        switch severity {
        case 3:
            // Maximum judgment
            playRandomSound([
                "really",
                "again",
                "i_expected_better",
                "disappointed"
            ])
        case 2:
            // Medium judgment
            playRandomSound([
                "sigh_2",
                "here_we_go",
                "productive",
                "sure_why_not"
            ])
        default:
            // Light judgment
            playRandomSound([
                "sigh_1",
                "sigh_3",
                "tsk_tsk"
            ])
        }
    }
}
