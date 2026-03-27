import Foundation
import Combine

/// Dramatic personality - reacts to tilts, impacts, and shakes
final class DramaticPersonality: BasePersonality {
    
    private var panicLevel: Double = 0
    private var panicTimer: Timer?
    
    init() {
        super.init(
            id: "dramatic",
            name: "Dramatic",
            icon: "🎭",
            description: "Reacts to tilts, impacts, and shakes with dramatic flair"
        )
    }
    
    override func activate() {
        print("🎭 Dramatic personality activated")
        
        // Listen for tilt events
        eventBus.tiltEvent
            .sink { [weak self] event in
                self?.handleTilt(event)
            }
            .store(in: &cancellables)
        
        // Listen for impact events
        eventBus.impactEvent
            .sink { [weak self] event in
                self?.handleImpact(event)
            }
            .store(in: &cancellables)
        
        // Listen for shake events
        eventBus.shakeEvent
            .sink { [weak self] in
                self?.handleShake()
            }
            .store(in: &cancellables)
        
        // Start panic decay timer
        panicTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.decayPanic()
        }
    }
    
    override func deactivate() {
        super.deactivate()
        panicTimer?.invalidate()
        panicTimer = nil
        panicLevel = 0
        print("🎭 Dramatic personality deactivated")
    }
    
    // MARK: - Event Handlers
    
    private func handleTilt(_ event: TiltEvent) {
        // Increase panic based on tilt angle
        let panicIncrease = event.angle / 90.0  // 0-1 based on angle
        panicLevel = min(1.0, panicLevel + panicIncrease * 0.3)
        
        if event.angle > 30 {
            // Getting serious
            if panicLevel > 0.7 {
                playRandomSound(["scream_1", "scream_2", "why_would_you"])
            } else if panicLevel > 0.4 {
                playRandomSound(["gasp_1", "gasp_2", "careful"])
            } else {
                playRandomSound(["whoa", "hey"])
            }
        }
    }
    
    private func handleImpact(_ event: ImpactEvent) {
        // React based on impact intensity
        panicLevel = min(1.0, panicLevel + event.intensity * 0.5)
        
        if event.intensity > 0.7 {
            playRandomSound(["scream_1", "scream_2", "ow"])
        } else if event.intensity > 0.3 {
            playRandomSound(["ouch", "hey", "what_was_that"])
        }
    }
    
    private func handleShake() {
        panicLevel = 1.0
        playRandomSound(["stop_it", "im_gonna_be_sick", "why"])
    }
    
    private func decayPanic() {
        // Slowly reduce panic level when nothing is happening
        if panicLevel > 0 {
            panicLevel = max(0, panicLevel - 0.05)
            
            // Relieved sound when calming down from high panic
            if panicLevel < 0.2 && panicLevel > 0.1 {
                playRandomSound(["phew", "okay", "thats_better"])
            }
        }
    }
}
