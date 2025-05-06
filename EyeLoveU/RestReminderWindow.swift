import SwiftUI
import AppKit

import Combine

struct RestReminderWindow: View {
    @Binding var isPresented: Bool
    @ObservedObject var timerModel: RestTimerModel
    var canSkip: Bool
    var onSkip: () -> Void
    // 每次開啟視窗時隨機一個深色
    private let bgColor: Color = {
        Color(
            .sRGB,
            red: Double.random(in: 0.05...0.25),
            green: Double.random(in: 0.05...0.25),
            blue: Double.random(in: 0.05...0.25),
            opacity: 1.0
        )
    }()
    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            VStack(spacing: 36) {
                Text(NSLocalizedString("restTitle", comment: "護眼休息時間"))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 6)
                HStack(alignment: .lastTextBaseline, spacing: 12) {
                    Text(String(format: "%02d", timerModel.restSeconds/60))
                        .font(.system(size: 72, weight: .heavy, design: .monospaced))
                        .foregroundColor(.yellow)
                    Text(":")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                    Text(String(format: "%02d", timerModel.restSeconds%60))
                        .font(.system(size: 72, weight: .heavy, design: .monospaced))
                        .foregroundColor(.yellow)
                }
                Text(NSLocalizedString("restText", comment: "請離開螢幕、放鬆眼睛，休息片刻！"))
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.top, 12)
                if canSkip {
                    Button(action: onSkip) {
                        Text(NSLocalizedString("restSkip", comment: "SKIP"))
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            //.background(Color.white.opacity(0.2))
                            //.cornerRadius(18)
                    }
                    .padding(.top, 24)
                }
            }
            .padding(60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

class RestReminderWindowController: NSWindowController {
    init(contentView: NSView) {
        let window = NSWindow(contentRect: NSScreen.main?.frame ?? NSRect(x:0, y:0, width:800, height:600),
                              styleMask: [.borderless],
                              backing: .buffered, defer: false)
        window.level = .mainMenu + 1
        window.isOpaque = true
        window.backgroundColor = .black
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.contentView = contentView
        super.init(window: window)
    }
    required init?(coder: NSCoder) { fatalError() }
}
