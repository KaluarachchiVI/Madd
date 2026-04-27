import SwiftUI

/// Visual tokens aligned with `designs/src/styles/theme.css` and screen components.
enum DesignTokens {
    static let background = Color(red: 0.969, green: 0.969, blue: 0.961) // #F7F7F5
    static let card = Color.white
    static let border = Color(red: 0.898, green: 0.906, blue: 0.922) // #E5E7EB
    static let textPrimary = Color(red: 0.067, green: 0.067, blue: 0.067) // #111111
    static let textSecondary = Color(red: 0.333, green: 0.333, blue: 0.333) // #555555
    static let textTertiary = Color(red: 0.533, green: 0.533, blue: 0.533) // #888888
    static let textQuaternary = Color(red: 0.667, green: 0.667, blue: 0.667) // #AAAAAA
    static let primary = Color(red: 0.059, green: 0.463, blue: 0.431) // #0F766E
    static let primaryLight = Color(red: 0.078, green: 0.722, blue: 0.651) // #14B8A6
    static let destructive = Color(red: 0.863, green: 0.149, blue: 0.149) // #DC2626
    static let bannerErrorBackground = Color(red: 1, green: 0.949, blue: 0.949) // #FEF2F2
    static let bannerErrorBorder = Color(red: 0.988, green: 0.647, blue: 0.647) // #FCA5A5
    static let dietaryPillBackground = Color(red: 0.996, green: 0.953, blue: 0.780) // #FEF3C7
    static let dietaryPillForeground = Color(red: 0.573, green: 0.251, blue: 0.059) // #92400E
    static let diaryIconBackground = Color(red: 0.941, green: 0.992, blue: 0.980) // #F0FDFA
    static let chipNotInBackground = Color(red: 0.953, green: 0.957, blue: 0.961) // #F3F4F6
    static let chipNotInForeground = Color(red: 0.420, green: 0.447, blue: 0.502) // #6B7280
    static let chipCheckedInBackground = Color(red: 0.820, green: 0.988, blue: 0.898) // #D1FAE5
    static let chipCheckedInForeground = Color(red: 0.024, green: 0.373, blue: 0.275) // #065F46
    static let chipCheckedOutBackground = Color(red: 0.859, green: 0.918, blue: 0.996) // #DBEAFE
    static let chipCheckedOutForeground = Color(red: 0.118, green: 0.251, blue: 0.686) // #1E40AF

    static let cornerRadius: CGFloat = 10
    static let buttonHeight: CGFloat = 50
    static let shadowOpacity: Double = 0.06
}
