import Foundation
import CoreGraphics

/// Monitors user idle time
final class IdleMonitor {
    static let shared = IdleMonitor()
    
    private var timer: Timer?
    private var lastIdleTime: TimeInterval = 0
    private var wasIdle = false
    
    private let idleThreshold: TimeInterval = 300  // 5 minutes
    private let eventBus = EventBus.shared
    
    private init() {}
    
    // MARK: - Public API
    
    func startMonitoring() {
        // Check every 10 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            self?.checkIdleTime()
        }
        
        print("✅ Idle monitoring started")
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        print("⏹️ Idle monitoring stopped")
    }
    
    // MARK: - Private
    
    private func checkIdleTime() {
        let idleTime = currentIdleTime
        
        // Publish idle time changes
        if abs(idleTime - lastIdleTime) > 5 {
            eventBus.idleTimeChanged.send(idleTime)
        }
        
        // Check if user returned from being idle
        let isCurrentlyIdle = idleTime > idleThreshold
        
        if wasIdle && !isCurrentlyIdle {
            // User returned!
            eventBus.userReturned.send()
        }
        
        wasIdle = isCurrentlyIdle
        lastIdleTime = idleTime
    }
    
    /// Get current idle time in seconds
    var currentIdleTime: TimeInterval {
        let eventSource = CGEventSource(stateID: .hidSystemState)
        let idleTime = eventSource?.secondsSinceLastEventType(.mouseMoved) ?? 0
        return idleTime
    }
}
