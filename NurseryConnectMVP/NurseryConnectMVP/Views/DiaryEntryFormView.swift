import SwiftUI
import SwiftData

struct DiaryEntryFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let child: Child
    @StateObject private var viewModel = ChildrenViewModel()

    @State private var selectedType: DiaryEntryType = .activity
    @State private var entryDate = Date()
    @State private var entryTime = Date()
    @State private var note = ""
    @State private var isSignificantUpdate = false
    @State private var notesError: String?
    @State private var showSuccess = false

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                IOSNavBar(title: "New diary entry", onBack: { dismiss() })

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        entryTypeChips

                        HStack(alignment: .top, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(DesignTokens.textPrimary)
                                DatePicker("", selection: $entryDate, displayedComponents: [.date])
                                    .labelsHidden()
                                    .tint(DesignTokens.primary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Time")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(DesignTokens.textPrimary)
                                DatePicker("", selection: $entryTime, displayedComponents: [.hourAndMinute])
                                    .labelsHidden()
                                    .tint(DesignTokens.primary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        IOSFormTextField(
                            label: "Notes",
                            text: $note,
                            placeholder: "What happened? Include enough detail for handover.",
                            multiline: true,
                            lineCount: 5,
                            required: true,
                            helper: nil,
                            error: notesError
                        )
                        .onChange(of: note) { _, newValue in
                            if notesError != nil, !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                notesError = nil
                            }
                        }

                        significantToggleRow

                        IOSPrimaryButton(title: "Save entry") {
                            saveEntry()
                        }
                        .accessibilityIdentifier("saveDiaryEntryButton")

                        Text(
                            "Only record information needed for care and safeguarding. Avoid unnecessary personal details."
                        )
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(DesignTokens.textTertiary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                }
            }
            .background(DesignTokens.background)

            if showSuccess {
                Text("Saved")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(DesignTokens.textPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous))
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .padding(.top, 72)
            }
        }
        .accessibilityIdentifier("diaryEntryFormScreen")
        .toolbar(.hidden, for: .navigationBar)
        .alert("Validation Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), actions: {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        }, message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        })
    }

    private var entryTypeChips: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Entry type")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(DesignTokens.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(DiaryEntryType.allCases) { type in
                        Button {
                            selectedType = type
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: type.symbolName)
                                    .font(.system(size: 22, weight: .medium))
                                Text(type.chipTitle)
                                    .font(.system(size: 13, weight: .medium))
                                    .lineLimit(1)
                            }
                            .foregroundStyle(selectedType == type ? Color.white : DesignTokens.textPrimary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous)
                                    .fill(selectedType == type ? DesignTokens.primary : DesignTokens.card)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous)
                                    .stroke(selectedType == type ? Color.clear : DesignTokens.border, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private var significantToggleRow: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                isSignificantUpdate.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .strokeBorder(isSignificantUpdate ? DesignTokens.primary : DesignTokens.border, lineWidth: 2)
                        .background(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(isSignificantUpdate ? DesignTokens.primary : Color.white)
                        )
                        .frame(width: 24, height: 24)
                    if isSignificantUpdate {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text("Significant update")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(DesignTokens.textPrimary)
                Text("Flag if parents should be alerted in a full system.")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(DesignTokens.textTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(DesignTokens.card)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous)
                .stroke(DesignTokens.border, lineWidth: 1)
        )
    }

    private func combinedTimestamp() -> Date {
        let cal = Calendar.current
        let d = cal.dateComponents([.year, .month, .day], from: entryDate)
        let t = cal.dateComponents([.hour, .minute], from: entryTime)
        var merged = DateComponents()
        merged.year = d.year
        merged.month = d.month
        merged.day = d.day
        merged.hour = t.hour
        merged.minute = t.minute
        return cal.date(from: merged) ?? entryDate
    }

    private func saveEntry() {
        do {
            try DiaryValidator.validate(payload: note)
            notesError = nil
        } catch {
            notesError = error.localizedDescription
            return
        }

        viewModel.addDiaryEntry(
            context: modelContext,
            child: child,
            type: selectedType,
            timestamp: combinedTimestamp(),
            payload: note,
            isSignificant: isSignificantUpdate
        )

        if viewModel.errorMessage == nil {
            showSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                dismiss()
            }
        }
    }
}
