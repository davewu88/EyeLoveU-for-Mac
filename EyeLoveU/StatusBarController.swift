import AppKit
import SwiftUI

class StatusBarController {
    private var preRestAlertController: NSWindowController?

    private var statusItem: NSStatusItem
    private var menu: NSMenu
    private var idleMonitor = IdleMonitor()
    private var workSeconds: Int = 0
    @AppStorage("workMinutes") private var workLimitMinutes: Int = 40
    @AppStorage("restMinutes") private var restMinutes: Int = 5
    @AppStorage("canSkip") private var canSkip: Bool = true
    @AppStorage("idleThreshold") private var idleThreshold: Double = 180
    private var infoItem: NSMenuItem!
    private var isIdle: Bool = false
    private var isResting: Bool = false
    private var restTimerModel: RestTimerModel? = nil
    private var restWindowController: NSWindowController?


    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarIcon")
            //button.image?.isTemplate = true // 支援 dark mode
        }
        menu = NSMenu()
        infoItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        infoItem.isEnabled = false
        menu.addItem(infoItem)
        // 新增立即休息項目
        let restNowItem = NSMenuItem(title: NSLocalizedString("restnow", comment: "立即休息"), action: #selector(restNow), keyEquivalent: "r")
        restNowItem.target = self
        menu.addItem(restNowItem)
        menu.addItem(NSMenuItem.separator())
        let settingsItem = NSMenuItem(title: NSLocalizedString("settings", comment: "偏好設定"), action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)
        let quitItem = NSMenuItem(title: NSLocalizedString("quit", comment: "離開程式"), action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        menu.autoenablesItems = false
        statusItem.menu = menu

        idleMonitor.onIdleUpdate = { [weak self] idle in
            self?.updateWorkTime(idleSeconds: idle)
        }
        idleMonitor.startMonitoring()
    }
    private func updateWorkTime(idleSeconds: Double) {
        if isResting {
            // 休息倒數中
            restTimerModel?.restSeconds -= 1
            if let seconds = restTimerModel?.restSeconds, seconds <= 0 {
                // 播放結束休息音效
                NSSound(named: NSSound.Name("Submarine"))?.play()
                closeRestWindow()
                isResting = false
                workSeconds = 0
            }
            return
        }
        if idleSeconds < idleThreshold {
            if isIdle {
                // 剛從 idle 恢復，計時從 0 重新開始
                isIdle = false
                workSeconds = 0
            }
            workSeconds += 1
        } else {
            // 進入 idle 狀態
            isIdle = true
        }
        let workedMinutes = workSeconds / 60
        let workedSeconds = workSeconds % 60
        let leftSecondsTotal = max(workLimitMinutes * 60 - workSeconds, 0)
        let leftMinutes = leftSecondsTotal / 60
        let leftSeconds = leftSecondsTotal % 60

        DispatchQueue.main.async {
            self.infoItem.title = String(format: NSLocalizedString("workTimer", comment: "你已經工作 %02d分%02d秒了，再過 %02d分%02d秒開始休息"), workedMinutes, workedSeconds, leftMinutes, leftSeconds)
            self.menu.update() // 強制 popup menu 內容刷新
        }
        // 距離休息1分鐘時彈出警告
        if leftSecondsTotal == 60 {
            showPreRestAlert()
        }
        if workSeconds >= workLimitMinutes * 60 {
            closePreRestAlert()
            startRest()
        }
    }
    private func showPreRestAlert() {
        // 若已顯示則不重複彈出
        if preRestAlertController != nil { return }
        let alertView = NSHostingView(rootView: PreRestAlertView(onClose: { [weak self] in
            self?.closePreRestAlert()
        }))
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 380, height: 120),
                              styleMask: [.titled, .closable],
                              backing: .buffered, defer: false)
        window.center()
        window.level = .floating
        window.title = NSLocalizedString("preRestAlert", comment: "休息即將開始")
        window.contentView = alertView
        let controller = NSWindowController(window: window)
        preRestAlertController = controller
        controller.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    private func closePreRestAlert() {
        preRestAlertController?.close()
        preRestAlertController = nil
    }
    private func startRest() {
        isResting = true
        // 播放開始休息音效
        NSSound(named: NSSound.Name("Glass"))?.play()
        let timerModel = RestTimerModel(restSeconds: restMinutes * 60)
        self.restTimerModel = timerModel
        let contentView = NSHostingView(rootView: RestReminderWindow(isPresented: .constant(true), timerModel: timerModel, canSkip: canSkip) {
            self.closeRestWindow()
            self.isResting = false
            self.workSeconds = 0
        })
        let windowController = RestReminderWindowController(contentView: contentView)
        self.restWindowController = windowController
        windowController.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    // 不再需要 updateRestWindow，restSeconds 由 ObservableObject 自動刷新

    private func closeRestWindow() {
        restWindowController?.close()
        restWindowController = nil
    }
    @objc func restNow() {
        if !isResting {
            startRest()
        }
    }
    @objc func openSettings() {
        if let existing = SettingsWindowController.shared {
            existing.show()
        } else {
            let controller = SettingsWindowController()
            SettingsWindowController.shared = controller
            controller.show()
        }
    }
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}
