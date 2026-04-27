import SwiftUI

struct IOSFormTextField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var multiline: Bool = false
    var lineCount: Int = 5
    var required: Bool = false
    var helper: String?
    var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text(label)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(DesignTokens.textPrimary)
                if required {
                    Text("*")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(DesignTokens.destructive)
                }
            }

            Group {
                if multiline {
                    TextField(placeholder, text: $text, axis: .vertical)
                        .lineLimit(lineCount, reservesSpace: true)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(DesignTokens.textPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(DesignTokens.card)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous)
                    .strokeBorder(error != nil ? DesignTokens.destructive : DesignTokens.border, lineWidth: error != nil ? 2 : 1)
            )

            if let error, !error.isEmpty {
                Text(error)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(DesignTokens.destructive)
            } else if let helper, !helper.isEmpty {
                Text(helper)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(DesignTokens.textTertiary)
            }
        }
    }
}
