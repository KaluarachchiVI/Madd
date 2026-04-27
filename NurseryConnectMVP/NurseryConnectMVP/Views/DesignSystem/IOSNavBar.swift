import SwiftUI

struct IOSNavBar: View {
    let title: String
    var largeTitle: Bool = false
    var onBack: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                if let onBack {
                    Button(action: onBack) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 17, weight: .regular))
                        }
                        .foregroundStyle(DesignTokens.primary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Back")
                } else if !largeTitle {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(DesignTokens.textPrimary)
                        .frame(maxWidth: .infinity)
                }
                Spacer(minLength: 0)
            }
            .frame(height: 44)
            .padding(.horizontal, 16)

            if largeTitle {
                Text(title)
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(DesignTokens.textPrimary)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
            }

            Rectangle()
                .fill(DesignTokens.border)
                .frame(height: 1)
        }
        .background(DesignTokens.background)
    }
}
