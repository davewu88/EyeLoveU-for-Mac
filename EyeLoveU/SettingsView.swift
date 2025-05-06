import SwiftUI

struct SettingsView: View {
    @AppStorage("autoLaunch") private var autoLaunchStore = false
    @AppStorage("workMinutes") private var workMinutesStore = 40
    @AppStorage("restMinutes") private var restMinutesStore = 5
    @AppStorage("canSkip") private var canSkipStore = true
    @AppStorage("idleThreshold") private var idleThresholdStore: Double = 300
    @State private var autoLaunch: Bool = false
    @State private var workMinutes: Int = 40
    @State private var restMinutes: Int = 5
    @State private var canSkip: Bool = true
    @State private var idleThreshold: Double = 300
    @State private var showAbout = false
    @Environment(\.presentationMode) var presentationMode
    @State private var firstAppear = true
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Toggle(NSLocalizedString("開機自動啟動", comment: "Auto Launch at Login"), isOn: $autoLaunch) // [暫時隱藏]
            HStack {
                Text(NSLocalizedString("workTime", comment: "Work Time"))
                TextField("", value: $workMinutes, formatter: NumberFormatter())
                    .frame(width: 40)
                Text(NSLocalizedString("min", comment: "minutes"))
            }
            HStack {
                Text(NSLocalizedString("restTime", comment: "Rest Time"))
                TextField("", value: $restMinutes, formatter: NumberFormatter())
                    .frame(width: 40)
                Text(NSLocalizedString("min", comment: "minutes"))
            }
            Toggle(NSLocalizedString("canSkip", comment: "Allow SKIP Rest"), isOn: $canSkip)
            HStack {
                Text(NSLocalizedString("idleThreshold", comment: "Idle Threshold:"))
                TextField("", value: $idleThreshold, formatter: NumberFormatter())
                    .frame(width: 60)
                Text(NSLocalizedString("sec", comment: "seconds"))
            }
            HStack {
                Button(NSLocalizedString("restoreDefaults", comment: "Restore Defaults")) {
                    autoLaunch = false; workMinutes = 40; restMinutes = 5; canSkip = true; idleThreshold = 300
                }
                Button(NSLocalizedString("about", comment: "About...")) { showAbout = true }
                Button(NSLocalizedString("support", comment: "Support…")) {
                    if let url = URL(string: "https://www.eyeloveucare.com") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
            HStack {
                Spacer()
                Button(NSLocalizedString("ok", comment: "OK")) {
                    autoLaunchStore = autoLaunch
                    workMinutesStore = workMinutes
                    restMinutesStore = restMinutes
                    canSkipStore = canSkip
                    idleThresholdStore = idleThreshold
                    NSApp.keyWindow?.close()
                }
                Button(NSLocalizedString("cancel", comment: "Cancel")) {
                    // 不儲存，還原 State
                    autoLaunch = autoLaunchStore
                    workMinutes = workMinutesStore
                    restMinutes = restMinutesStore
                    canSkip = canSkipStore
                    idleThreshold = idleThresholdStore
                    NSApp.keyWindow?.close()
                }
                Button(NSLocalizedString("exit", comment: "Exit")) { NSApp.terminate(nil) }
            }
        }
        .onAppear {
            if firstAppear {
                autoLaunch = autoLaunchStore
                workMinutes = workMinutesStore
                restMinutes = restMinutesStore
                canSkip = canSkipStore
                idleThreshold = idleThresholdStore
                firstAppear = false
            }
        }
        .padding(24)
        .frame(width: 350)
        .sheet(isPresented: $showAbout) {
            VStack {
                Text("EyeLoveU for macOS v1.0")
                Text("Copyright © 2025 EyeLoveU,")
                Text("Free to use under the MIT license.")
                Button("OK") { showAbout = false }
            }.padding(40)
        }
    }
}
