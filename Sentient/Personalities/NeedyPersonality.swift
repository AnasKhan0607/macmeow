import Foundation
import Combine

/// Needy personality - misses you when you're away, happy when you return
final class NeedyPersonality: BasePersonality {
    
    private var missTimer: Timer?
    private var lastMissTime: Date = .distantPast
    private let missCooldown: TimeInterval = 120  // 2 minutes between missing you
    
    // Idle thresholds (in seconds)
    private let idleThresholdLight: TimeInterval = 300   // 5 min
    private let idleThresholdMedium: TimeInterval = 600  // 10 min
    private let idleThresholdHeavy: TimeInterval = 900   // 15 min
    
    private var currentIdleTime: TimeInterval = 0
    private var hasGreetedOnReturn = false
    
    init() {
        super.init(
            id: "needy",
            name: "Needy",
            icon: "🥺",
            description: "Misses you when idle, happy when you return"
        )
    }
    
    override func activate() {
        print("🥺 Needy personality activated")
        
        // Listen for idle time changes
        eventBus.idleTimeChanged
            .sink { [weak self] idleTime in
                self?.handleIdleChange(idleTime)
            }
            .store(in: &cancellables)
        
        // Listen for user returns
        eventBus.userReturned
            .sink { [weak self] in
                self?.handleUserReturn()
            }
            .store(in: &cancellables)
        
        // Listen for lid events
        eventBus.lidClosed
            .sink { [weak self] in
                self?.handleLidClose()
            }
            .store(in: &cancellables)
        
        eventBus.lidOpened
            .sink { [weak self] in
                self?.handleLidOpen()
            }
            .store(in: &cancellables)
        
        // Start periodic missing check
        missTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.checkIfShouldMiss()
        }
    }
    
    override func deactivate() {
        super.deactivate()
        missTimer?.invalidate()
        missTimer = nil
        print("🥺 Needy personality deactivated")
    }
    
    // MARK: - Event Handlers
    
    private func handleIdleChange(_ idleTime: TimeInterval) {
        currentIdleTime = idleTime
        
        // Reset greet flag if user was active
        if idleTime < 10 {
            hasGreetedOnReturn = false
        }
    }
    
    private func handleUserReturn() {
        // Only greet once per idle session
        guard !hasGreetedOnReturn else { return }
        
        // Only greet if they were gone long enough
        if currentIdleTime >= idleThresholdLight {
            greetUser(afterIdleTime: currentIdleTime)
            hasGreetedOnReturn = true
        }
    }
    
    private func handleLidClose() {
        // Sad goodbye when lid closes
        playRandomSound(["dont_leave", "miss_you", "sad_whimper"])
    }
    
    private func handleLidOpen() {
        // Happy greeting when lid opens
        playRandomSound(["youre_back", "hello", "yay"])
    }
    
    private func checkIfShouldMiss() {
        // Express loneliness while idle
        let now = Date()
        guard now.timeIntervalSince(lastMissTime) >= missCooldown else { return }
        
        if currentIdleTime >= idleThresholdHeavy {
            // Very lonely
            playRandomSound(["so_lonely", "come_back", "where_are_you"])
            lastMissTime = now
        } else if currentIdleTime >= idleThresholdMedium {
            // Getting lonely
            playRandomSound(["miss_you", "sad_whimper"])
            lastMissTime = now
        }
    }
    
    private func greetUser(afterIdleTime: TimeInterval) {
        if afterIdleTime >= idleThresholdHeavy {
            // Very excited they're back
            playRandomSound(["finally", "i_was_worried", "youre_back"])
        } else if afterIdleTime >= idleThresholdMedium {
            // Happy they're back
            playRandomSound(["youre_back", "yay", "hello"])
        } else {
            // Light greeting
            playRandomSound(["hello"])
        }
    }
}
