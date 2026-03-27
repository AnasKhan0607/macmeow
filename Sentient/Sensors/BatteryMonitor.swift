import Foundation
import IOKit.ps

/// Monitors battery level and charging state
final class BatteryMonitor {
    static let shared = BatteryMonitor()
    
    private var timer: Timer?
    private var lastLevel: Int = 100
    private var lastCharging: Bool = false
    
    private let eventBus = EventBus.shared
    
    private init() {}
    
    // MARK: - Public API
    
    func startMonitoring() {
        // Check immediately
        checkBattery()
        
        // Then check every 30 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.checkBattery()
        }
        
        print("✅ Battery monitoring started")
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        print("⏹️ Battery monitoring stopped")
    }
    
    // MARK: - Private
    
    private func checkBattery() {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef],
              let source = sources.first,
              let description = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any] else {
            return
        }
        
        // Get battery level
        if let currentCapacity = description[kIOPSCurrentCapacityKey] as? Int {
            if currentCapacity != lastLevel {
                lastLevel = currentCapacity
                eventBus.batteryLevelChanged.send(currentCapacity)
            }
        }
        
        // Get charging state
        let isCharging = description[kIOPSIsChargingKey] as? Bool ?? false
        if isCharging != lastCharging {
            lastCharging = isCharging
            eventBus.chargingStateChanged.send(isCharging)
        }
    }
    
    /// Get current battery level (0-100)
    var currentLevel: Int {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef],
              let source = sources.first,
              let description = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any],
              let capacity = description[kIOPSCurrentCapacityKey] as? Int else {
            return 100
        }
        return capacity
    }
    
    /// Check if currently charging
    var isCharging: Bool {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef],
              let source = sources.first,
              let description = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any] else {
            return false
        }
        return description[kIOPSIsChargingKey] as? Bool ?? false
    }
}
