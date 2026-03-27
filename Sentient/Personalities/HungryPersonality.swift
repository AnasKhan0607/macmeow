import Foundation
import Combine

/// Hungry personality - complains about battery level
final class HungryPersonality: BasePersonality {
    
    private var lastComplaintLevel: Int = 100
    private var hasComplainedAtCurrentLevel = false
    
    init() {
        super.init(
            id: "hungry",
            name: "Hungry",
            icon: "🍔",
            description: "Gets hungry as battery drains, satisfied when charged"
        )
    }
    
    override func activate() {
        print("🍔 Hungry personality activated")
        
        // Listen for battery level changes
        eventBus.batteryLevelChanged
            .sink { [weak self] level in
                self?.handleBatteryLevel(level)
            }
            .store(in: &cancellables)
        
        // Listen for charging state changes
        eventBus.chargingStateChanged
            .sink { [weak self] isCharging in
                self?.handleChargingState(isCharging)
            }
            .store(in: &cancellables)
    }
    
    override func deactivate() {
        super.deactivate()
        print("🍔 Hungry personality deactivated")
    }
    
    // MARK: - Event Handlers
    
    private func handleBatteryLevel(_ level: Int) {
        // Only complain at certain thresholds, and only once per threshold
        let thresholds = [50, 30, 20, 10, 5]
        
        for threshold in thresholds {
            if level <= threshold && lastComplaintLevel > threshold {
                complainAtLevel(level)
                lastComplaintLevel = level
                break
            }
        }
        
        // Track if we've recovered
        if level > lastComplaintLevel + 10 {
            lastComplaintLevel = level
        }
    }
    
    private func complainAtLevel(_ level: Int) {
        switch level {
        case 0...5:
            // Desperate
            playRandomSound(["dying", "help_me", "so_weak", "goodbye_world"])
        case 6...10:
            // Very hungry
            playRandomSound(["starving", "please_feed_me", "so_hungry"])
        case 11...20:
            // Hungry
            playRandomSound(["hungry", "feed_me", "stomach_growl_loud"])
        case 21...30:
            // Getting hungry
            playRandomSound(["getting_hungry", "stomach_growl", "could_use_snack"])
        case 31...50:
            // Mild hunger
            playRandomSound(["little_hungry", "stomach_growl_soft", "hmm_hungry"])
        default:
            break
        }
    }
    
    private func handleChargingState(_ isCharging: Bool) {
        if isCharging {
            // Plugged in - satisfied!
            let level = BatteryMonitor.shared.currentLevel
            
            if level < 20 {
                playRandomSound(["finally_food", "yes_feed_me", "thank_you"])
            } else {
                playRandomSound(["ahh_satisfied", "yummy", "thats_the_stuff"])
            }
        }
        
        // Check for "overfed" at 100%
        if !isCharging && BatteryMonitor.shared.currentLevel >= 100 {
            // Slight delay to make sure we're at 100%
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                if BatteryMonitor.shared.currentLevel >= 100 {
                    self?.playRandomSound(["too_full", "cant_eat_more", "stuffed"])
                }
            }
        }
    }
}
