import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController?
    private var eventBus: EventBus?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize core systems
        eventBus = EventBus.shared
        
        // Setup menu bar
        statusBarController = StatusBarController()
        
        // Start monitoring
        startMonitors()
        
        // Hide dock icon (menu bar only app)
        NSApp.setActivationPolicy(.accessory)
    }
    
    private func startMonitors() {
        // Start accelerometer monitoring
        AccelerometerMonitor.shared.startMonitoring()
        
        // Start battery monitoring
        BatteryMonitor.shared.startMonitoring()
        
        // Start app monitoring (for judgmental personality)
        AppMonitor.shared.startMonitoring()
        
        // Start idle monitoring
        IdleMonitor.shared.startMonitoring()
        
        // Start lid monitoring (for needy personality)
        LidMonitor.shared.startMonitoring()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Cleanup
        AccelerometerMonitor.shared.stopMonitoring()
        BatteryMonitor.shared.stopMonitoring()
        AppMonitor.shared.stopMonitoring()
        IdleMonitor.shared.stopMonitoring()
        LidMonitor.shared.stopMonitoring()
    }
}
