import Foundation
import Combine

/// Central event dispatcher for all sensor events
final class EventBus {
    static let shared = EventBus()
    
    // MARK: - Event Publishers
    
    /// Accelerometer events
    let tiltEvent = PassthroughSubject<TiltEvent, Never>()
    let impactEvent = PassthroughSubject<ImpactEvent, Never>()
    let shakeEvent = PassthroughSubject<Void, Never>()
    
    /// Battery events
    let batteryLevelChanged = PassthroughSubject<Int, Never>()
    let chargingStateChanged = PassthroughSubject<Bool, Never>()
    
    /// App events
    let appLaunched = PassthroughSubject<String, Never>()
    let appClosed = PassthroughSubject<String, Never>()
    
    /// Idle events
    let idleTimeChanged = PassthroughSubject<TimeInterval, Never>()
    let userReturned = PassthroughSubject<Void, Never>()
    
    /// Lid events
    let lidClosed = PassthroughSubject<Void, Never>()
    let lidOpened = PassthroughSubject<Void, Never>()
    
    private init() {}
}

// MARK: - Event Types

struct TiltEvent {
    let angle: Double  // Degrees from level
    let direction: TiltDirection
}

enum TiltDirection {
    case forward
    case backward
    case left
    case right
}

struct ImpactEvent {
    let intensity: Double  // 0.0 - 1.0
}
