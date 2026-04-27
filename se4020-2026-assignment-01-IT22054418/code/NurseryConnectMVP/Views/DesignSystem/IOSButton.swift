import SwiftUI

struct IOSPrimaryButton: View {
    let title: String
    var fullWidth: Bool = true
    var disabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: fullWidth ? .infinity : nil)
                .frame(height: DesignTokens.buttonHeight)
                .background(disabled ? DesignTokens.primary.opacity(0.4) : DesignTokens.primary)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
}

struct IOSSecondaryButton: View {
    let title: String
    var fullWidth: Bool = true
    var disabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: fullWidth ? .infinity : nil)
                .frame(height: DesignTokens.buttonHeight)
                .background(DesignTokens.card)
                .foregroundStyle(DesignTokens.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous)
                        .stroke(DesignTokens.primary, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .opacity(disabled ? 0.4 : 1)
    }
}
