import Foundation
import AppKit

/// Monitors app launches to detect "guilty pleasure" apps
final class AppMonitor {
    static let shared = AppMonitor()
    
    private var observer: NSObjectProtocol?
    private let eventBus = EventBus.shared
    
    private init() {}
    
    // MARK: - Public API
    
    func startMonitoring() {
        // Watch for app activations
        observer = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleAppActivation(notification)
        }
        
        print("✅ App monitoring started")
    }
    
    func stopMonitoring() {
        if let observer = observer {
            NSWorkspace.shared.notificationCenter.removeObserver(observer)
        }
        observer = nil
        print("⏹️ App monitoring stopped")
    }
    
    // MARK: - Private
    
    private func handleAppActivation(_ notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
              let appName = app.localizedName else {
            return
        }
        
        eventBus.appLaunched.send(appName)
    }
}
