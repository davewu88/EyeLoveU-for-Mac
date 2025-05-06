import Foundation
import AppKit

class IdleMonitor {
    private var timer: Timer?
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private let eventMask: CGEventMask = (
        1 << CGEventType.mouseMoved.rawValue |
        1 << CGEventType.leftMouseDown.rawValue |
        1 << CGEventType.rightMouseDown.rawValue |
        1 << CGEventType.keyDown.rawValue |
        1 << CGEventType.flagsChanged.rawValue
    )
    private(set) var idleSeconds: Double = 0
    var onIdleUpdate: ((Double) -> Void)?
    private var lastEventTime: Date = Date()

    func startMonitoring() {
        print("[IdleMonitor] startMonitoring (CGEventTap)")
        stopMonitoring()
        // 安裝 CGEventTap 監聽全域事件
        let eventCallback: CGEventTapCallBack = { (proxy, type, event, refcon) in
            let monitor = Unmanaged<IdleMonitor>.fromOpaque(refcon!).takeUnretainedValue()
            monitor.lastEventTime = Date()
            return Unmanaged.passUnretained(event)
        }
        let refcon = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: eventCallback,
            userInfo: refcon
        )
        if let eventTap = eventTap {
            runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
        } else {
            print("[IdleMonitor] Failed to create event tap. (請檢查輔助使用權限)")
        }
        lastEventTime = Date()
        idleSeconds = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.idleSeconds = Date().timeIntervalSince(self.lastEventTime)
            //print("[IdleMonitor] tick, idleSeconds = \(self.idleSeconds)")
            self.onIdleUpdate?(self.idleSeconds)
        }
    }
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
        }
        if let runLoopSource = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        }
        eventTap = nil
        runLoopSource = nil
    }
    deinit {
        stopMonitoring()
    }
}
