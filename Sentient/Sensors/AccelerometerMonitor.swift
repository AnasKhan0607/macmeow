import Foundation
import IOKit
import IOKit.hid

/// Monitors the built-in accelerometer on Apple Silicon Macs
/// Uses IOKit HID to access the Bosch BMI286 IMU
final class AccelerometerMonitor {
    static let shared = AccelerometerMonitor()
    
    private var manager: IOHIDManager?
    private var isMonitoring = false
    
    // Calibration values
    private var baselineX: Double = 0
    private var baselineY: Double = 0
    private var baselineZ: Double = 0
    
    // Thresholds
    private let tiltThreshold: Double = 15.0  // Degrees
    private let impactThreshold: Double = 1.5  // G-force
    
    private let eventBus = EventBus.shared
    
    private init() {}
    
    // MARK: - Public API
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
        
        guard let manager = manager else {
            print("❌ Failed to create HID manager")
            return
        }
        
        // Match accelerometer devices
        let matchingDict: [String: Any] = [
            kIOHIDDeviceUsagePageKey as String: kHIDPage_GenericDesktop,
            kIOHIDDeviceUsageKey as String: kHIDUsage_GD_Pointer
        ]
        
        IOHIDManagerSetDeviceMatching(manager, matchingDict as CFDictionary)
        
        // Register callback
        let callback: IOHIDValueCallback = { context, result, sender, value in
            guard let context = context else { return }
            let monitor = Unmanaged<AccelerometerMonitor>.fromOpaque(context).takeUnretainedValue()
            monitor.handleValue(value)
        }
        
        let context = Unmanaged.passUnretained(self).toOpaque()
        IOHIDManagerRegisterInputValueCallback(manager, callback, context)
        
        // Schedule with run loop
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        
        // Open
        let result = IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))
        if result == kIOReturnSuccess {
            isMonitoring = true
            print("✅ Accelerometer monitoring started")
            calibrate()
        } else {
            print("❌ Failed to open HID manager: \(result)")
        }
    }
    
    func stopMonitoring() {
        guard isMonitoring, let manager = manager else { return }
        
        IOHIDManagerClose(manager, IOOptionBits(kIOHIDOptionsTypeNone))
        isMonitoring = false
        print("⏹️ Accelerometer monitoring stopped")
    }
    
    func calibrate() {
        // TODO: Sample current position as baseline
        print("📐 Calibrating accelerometer...")
    }
    
    // MARK: - Private
    
    private func handleValue(_ value: IOHIDValue) {
        let element = IOHIDValueGetElement(value)
        let usage = IOHIDElementGetUsage(element)
        let intValue = IOHIDValueGetIntegerValue(value)
        
        // Process accelerometer data
        // Usage 0x30 = X, 0x31 = Y, 0x32 = Z
        switch usage {
        case 0x30: // X axis
            processAcceleration(axis: "x", value: Double(intValue))
        case 0x31: // Y axis
            processAcceleration(axis: "y", value: Double(intValue))
        case 0x32: // Z axis
            processAcceleration(axis: "z", value: Double(intValue))
        default:
            break
        }
    }
    
    private func processAcceleration(axis: String, value: Double) {
        // Normalize and detect events
        // This is simplified - real implementation needs proper calibration
        
        let normalizedValue = value / 1000.0  // Convert to G-force approximation
        
        // Detect impact
        if abs(normalizedValue) > impactThreshold {
            let intensity = min(1.0, abs(normalizedValue) / 3.0)
            eventBus.impactEvent.send(ImpactEvent(intensity: intensity))
        }
        
        // Detect tilt (simplified)
        if axis == "x" && abs(normalizedValue) > 0.2 {
            let angle = asin(min(1, max(-1, normalizedValue))) * 180 / .pi
            let direction: TiltDirection = normalizedValue > 0 ? .right : .left
            eventBus.tiltEvent.send(TiltEvent(angle: abs(angle), direction: direction))
        }
    }
}
