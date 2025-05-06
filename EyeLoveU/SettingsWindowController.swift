import AppKit
import SwiftUI

class SettingsWindowController: NSWindowController {
    static var shared: SettingsWindowController?
    convenience init() {
        let hosting = NSHostingController(rootView: SettingsView())
        let window = NSWindow(contentViewController: hosting)
        window.title = "EyeLoveU "+NSLocalizedString("settings", comment: "偏好設定")
        window.styleMask = [.titled, .closable, .miniaturizable]
        window.setContentSize(NSSize(width: 380, height: 340))
        window.center()
        self.init(window: window)
    }
    func show() {
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
