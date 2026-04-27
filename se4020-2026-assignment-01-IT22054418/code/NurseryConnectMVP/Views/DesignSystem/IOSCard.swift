import SwiftUI

struct IOSCard<Content: View>: View {
    var title: String?
    @ViewBuilder var content: () -> Content

    init(title: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let title {
                Text(title.uppercased())
                    .font(.system(size: 13, weight: .semibold))
                    .tracking(0.5)
                    .foregroundStyle(DesignTokens.textTertiary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
            }

            VStack(alignment: .leading, spacing: 0) {
                content()
            }
            .background(DesignTokens.card)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(DesignTokens.shadowOpacity), radius: 4, x: 0, y: 2)
        }
    }
}

struct IOSCardRow: View {
    let label: String
    let value: String
    var showDivider: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(label)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(DesignTokens.textPrimary)
                Spacer()
                Text(value)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(DesignTokens.textTertiary)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            if showDivider {
                Rectangle()
                    .fill(DesignTokens.border)
                    .frame(height: 1)
                    .padding(.leading, 16)
            }
        }
    }
}
