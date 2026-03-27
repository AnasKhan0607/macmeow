import Foundation
import IOKit
import IOKit.pwr_mgt

/// Monitors MacBook lid open/close events
final class LidMonitor {
    static let shared = LidMonitor()
    
    private var notificationPort: IONotificationPortRef?
    private var notifier: io_object_t = 0
    private var isLidClosed = false
    
    private let eventBus = EventBus.shared
    
    private init() {}
    
    // MARK: - Public API
    
    func startMonitoring() {
        // Register for clamshell (lid) state changes
        let matchingDict = IOServiceMatching("IOPMrootDomain")
        
        notificationPort = IONotificationPortCreate(kIOMainPortDefault)
        guard let notificationPort = notificationPort else {
            print("❌ Failed to create notification port")
            return
        }
        
        let runLoopSource = IONotificationPortGetRunLoopSource(notificationPort).takeUnretainedValue()
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .defaultMode)
        
        // Get current lid state
        updateLidState()
        
        // Register for power state changes which include lid events
        var notifier: io_object_t = 0
        let callback: IOServiceInterestCallback = { refcon, service, messageType, messageArgument in
            guard let refcon = refcon else { return }
            let monitor = Unmanaged<LidMonitor>.fromOpaque(refcon).takeUnretainedValue()
            
            // kIOMessageSystemWillSleep, kIOMessageSystemHasPoweredOn, etc.
            monitor.handlePowerMessage(messageType: messageType)
        }
        
        let selfPtr = Unmanaged.passUnretained(self).toOpaque()
        
        let service = IOServiceGetMatchingService(kIOMainPortDefault, matchingDict)
        if service != 0 {
            IOServiceAddInterestNotification(
                notificationPort,
                service,
                kIOGeneralInterest,
                callback,
                selfPtr,
                &notifier
            )
            self.notifier = notifier
            IOObjectRelease(service)
        }
        
        print("✅ Lid monitoring started")
    }
    
    func stopMonitoring() {
        if notifier != 0 {
            IOObjectRelease(notifier)
            notifier = 0
        }
        if let port = notificationPort {
            IONotificationPortDestroy(port)
            notificationPort = nil
        }
        print("⏹️ Lid monitoring stopped")
    }
    
    // MARK: - Private
    
    private func updateLidState() {
        // Check AppleClamshellState property
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPMrootDomain"))
        guard service != 0 else { return }
        defer { IOObjectRelease(service) }
        
        if let clamshellState = IORegistryEntryCreateCFProperty(
            service,
            "AppleClamshellState" as CFString,
            kCFAllocatorDefault,
            0
        )?.takeRetainedValue() as? Bool {
            let wasLidClosed = isLidClosed
            isLidClosed = clamshellState
            
            // Notify if state changed
            if isLidClosed && !wasLidClosed {
                eventBus.lidClosed.send()
                print("🔒 Lid closed")
            } else if !isLidClosed && wasLidClosed {
                eventBus.lidOpened.send()
                print("🔓 Lid opened")
            }
        }
    }
    
    private func handlePowerMessage(messageType: UInt32) {
        // Update lid state on power events
        DispatchQueue.main.async { [weak self] in
            self?.updateLidState()
        }
    }
}
