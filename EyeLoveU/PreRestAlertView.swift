import SwiftUI

struct PreRestAlertView: View {
    var onClose: () -> Void
    var body: some View {
        VStack(spacing: 16) {
            Text(NSLocalizedString("preRestAlertTitle", comment: "即將進入護眼休息"))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            Text(NSLocalizedString("preRestAlertText", comment: "請儲存工作進度，1分鐘後將自動開始休息"))
                .font(.body)
                .foregroundColor(.primary)
            Button(NSLocalizedString("gotit", comment: "Got it")) {
                onClose()
            }
            .keyboardShortcut(.defaultAction)
            .padding(.top, 8)
        }
        .padding(24)
        .frame(minWidth: 320)
    }
}
