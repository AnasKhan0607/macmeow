import Foundation
import IOKit
import IOKit.hid

/// Monitors the built-in accelerometer on Apple Silicon Macs (M2+)
/// Uses IOKit HID to access the Bosch BMI286 IMU via AppleSPUHIDDevice
///
/// Based on research from: https://github.com/olvvier/apple-silicon-accelerometer
/// The sensor is accessed via vendor usage page 0xFF00, usage 3 (accelerometer)
/// Data comes as 22-byte HID reports with x/y/z as int32 at offsets 6, 10, 14
/// Values are divided by 65536 to convert to g-force
final class AccelerometerMonitor {
    static let shared = AccelerometerMonitor()
    
    private var device: IOHIDDevice?
    private var isMonitoring = false
    private let eventBus = EventBus.shared
    
    // Calibration - baseline values when Mac is level
    private var baselineX: Double = 0
    private var baselineY: Double = 0
    private var baselineZ: Double = 1.0  // 1g from gravity when level
    
    // Thresholds
    private let tiltThreshold: Double = 15.0  // Degrees to trigger tilt event
    private let impactThreshold: Double = 1.8  // G-force to trigger impact
    private let shakeThreshold: Double = 2.5   // G-force for shake
    
    // Smoothing
    private var lastX: Double = 0
    private var lastY: Double = 0
    private var lastZ: Double = 1.0
    private let smoothingFactor: Double = 0.3
    
    // Impact detection
    private var lastImpactTime: Date = .distantPast
    private let impactCooldown: TimeInterval = 0.5  // Seconds between impacts
    
    private init() {}
    
    // MARK: - Public API
    
    /// Check if accelerometer is available on this Mac
    static var isAvailable: Bool {
        // Check for AppleSPUHIDDevice in IOKit registry
        let matching = IOServiceMatching("AppleSPUHIDDevice")
        var iterator: io_iterator_t = 0
        let result = IOServiceGetMatchingServices(kIOMainPortDefault, matching, &iterator)
        
        if result == kIOReturnSuccess {
            let service = IOIteratorNext(iterator)
            IOObjectRelease(iterator)
            if service != 0 {
                IOObjectRelease(service)
                return true
            }
        }
        return false
    }
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        // Create HID manager
        guard let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone)) else {
            print("❌ Failed to create HID manager")
            return
        }
        
        // Match AppleSPUHIDDevice with vendor usage page 0xFF00
        let matchingDict: [String: Any] = [
            kIOHIDDeviceUsagePageKey as String: 0xFF00,  // Vendor-specific
            kIOHIDDeviceUsageKey as String: 3            // Accelerometer
        ]
        
        IOHIDManagerSetDeviceMatching(manager, matchingDict as CFDictionary)
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
        
        let openResult = IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))
        
        if openResult != kIOReturnSuccess {
            print("❌ Failed to open HID manager. Error: \(openResult)")
            print("   Note: Accelerometer access may require running as root (sudo)")
            return
        }
        
        // Get matched devices
        guard let deviceSet = IOHIDManagerCopyDevices(manager) as? Set<IOHIDDevice>,
              let device = deviceSet.first else {
            print("❌ No accelerometer device found")
            print("   This feature requires Apple Silicon Mac (M2 or later)")
            return
        }
        
        self.device = device
        
        // Register for input reports
        let context = Unmanaged.passUnretained(self).toOpaque()
        
        IOHIDDeviceRegisterInputReportCallback(
            device,
            UnsafeMutablePointer<UInt8>.allocate(capacity: 64),
            64,
            { context, result, sender, type, reportID, report, reportLength in
                guard let context = context else { return }
                let monitor = Unmanaged<AccelerometerMonitor>.fromOpaque(context).takeUnretainedValue()
                monitor.handleReport(report: report, length: reportLength)
            },
            context
        )
        
        isMonitoring = true
        print("✅ Accelerometer monitoring started")
        
        // Calibrate after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.calibrate()
        }
    }
    
    func stopMonitoring() {
        guard isMonitoring else { return }
        device = nil
        isMonitoring = false
        print("⏹️ Accelerometer monitoring stopped")
    }
    
    func calibrate() {
        // Store current values as baseline (assumes Mac is currently level)
        baselineX = lastX
        baselineY = lastY
        baselineZ = lastZ
        print("📐 Accelerometer calibrated: baseline = (\(baselineX), \(baselineY), \(baselineZ))")
    }
    
    // MARK: - Report Processing
    
    private func handleReport(report: UnsafeMutablePointer<UInt8>, length: CFIndex) {
        // Reports are 22 bytes with x/y/z as int32 at offsets 6, 10, 14
        guard length >= 18 else { return }
        
        // Extract raw values (little-endian int32)
        let rawX = extractInt32(from: report, at: 6)
        let rawY = extractInt32(from: report, at: 10)
        let rawZ = extractInt32(from: report, at: 14)
        
        // Convert to g-force (divide by 65536)
        let x = Double(rawX) / 65536.0
        let y = Double(rawY) / 65536.0
        let z = Double(rawZ) / 65536.0
        
        // Apply smoothing
        lastX = lastX * (1 - smoothingFactor) + x * smoothingFactor
        lastY = lastY * (1 - smoothingFactor) + y * smoothingFactor
        lastZ = lastZ * (1 - smoothingFactor) + z * smoothingFactor
        
        // Process for events
        processAcceleration(x: lastX, y: lastY, z: lastZ)
    }
    
    private func extractInt32(from buffer: UnsafeMutablePointer<UInt8>, at offset: Int) -> Int32 {
        let b0 = Int32(buffer[offset])
        let b1 = Int32(buffer[offset + 1]) << 8
        let b2 = Int32(buffer[offset + 2]) << 16
        let b3 = Int32(buffer[offset + 3]) << 24
        return b0 | b1 | b2 | b3
    }
    
    private func processAcceleration(x: Double, y: Double, z: Double) {
        // Calculate total acceleration magnitude
        let magnitude = sqrt(x * x + y * y + z * z)
        
        // Detect impact (sudden spike in acceleration)
        let now = Date()
        if magnitude > impactThreshold && now.timeIntervalSince(lastImpactTime) > impactCooldown {
            let intensity = min(1.0, (magnitude - 1.0) / 2.0)  // Normalize 1-3g to 0-1
            eventBus.impactEvent.send(ImpactEvent(intensity: intensity))
            lastImpactTime = now
            print("💥 Impact detected: \(String(format: "%.2f", magnitude))g, intensity: \(String(format: "%.2f", intensity))")
        }
        
        // Detect shake (very high magnitude)
        if magnitude > shakeThreshold {
            eventBus.shakeEvent.send()
            print("🫨 Shake detected: \(String(format: "%.2f", magnitude))g")
        }
        
        // Calculate tilt angles
        // Roll (side to side) = atan2(y, z)
        // Pitch (forward/back) = atan2(-x, sqrt(y*y + z*z))
        let roll = atan2(y, z) * 180.0 / .pi
        let pitch = atan2(-x, sqrt(y * y + z * z)) * 180.0 / .pi
        
        // Detect significant tilt
        if abs(roll) > tiltThreshold || abs(pitch) > tiltThreshold {
            let angle = max(abs(roll), abs(pitch))
            let direction: TiltDirection
            
            if abs(pitch) > abs(roll) {
                direction = pitch > 0 ? .backward : .forward
            } else {
                direction = roll > 0 ? .right : .left
            }
            
            eventBus.tiltEvent.send(TiltEvent(angle: angle, direction: direction))
        }
    }
}

// MARK: - Fallback for non-Apple Silicon Macs

extension AccelerometerMonitor {
    /// Use SMS (Sudden Motion Sensor) on older Intel Macs
    /// This is less precise but works without root
    func startSMSMonitoring() {
        // Older Intel Macs had an SMS for hard drive protection
        // Can be accessed via sms-motion-sensor or similar
        // For now, we'll just log that it's not supported
        print("⚠️ SMS fallback not implemented - Apple Silicon required")
    }
}
