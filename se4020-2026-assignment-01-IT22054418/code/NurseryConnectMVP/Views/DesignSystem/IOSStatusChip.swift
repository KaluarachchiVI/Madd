import SwiftUI

struct IOSStatusChip: View {
    let status: AttendanceStatus
    var large: Bool = false

    var body: some View {
        Text(label)
            .font(.system(size: large ? 15 : 13, weight: .semibold))
            .foregroundStyle(foreground)
            .padding(.horizontal, 12)
            .frame(height: large ? 32 : 24)
            .background(background)
            .clipShape(Capsule())
            .accessibilityLabel("Attendance status: \(label)")
    }

    private var label: String {
        switch status {
        case .notCheckedIn: return "Not in"
        case .checkedIn: return "Checked in"
        case .checkedOut: return "Checked out"
        }
    }

    private var background: Color {
        switch status {
        case .notCheckedIn: return DesignTokens.chipNotInBackground
        case .checkedIn: return DesignTokens.chipCheckedInBackground
        case .checkedOut: return DesignTokens.chipCheckedOutBackground
        }
    }

    private var foreground: Color {
        switch status {
        case .notCheckedIn: return DesignTokens.chipNotInForeground
        case .checkedIn: return DesignTokens.chipCheckedInForeground
        case .checkedOut: return DesignTokens.chipCheckedOutForeground
        }
    }
}
