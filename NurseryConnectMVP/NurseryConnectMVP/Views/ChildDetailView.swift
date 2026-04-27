import SwiftUI
import SwiftData

struct ChildDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var allEntries: [DiaryEntry]
    @Query private var allAttendance: [AttendanceRecord]

    let child: Child
    @StateObject private var viewModel = ChildrenViewModel()

    private var diaryEntriesToday: [DiaryEntry] {
        let cal = Calendar.current
        return allEntries
            .filter { $0.childID == child.id && cal.isDateInToday($0.timestamp) }
            .sorted { $0.timestamp > $1.timestamp }
    }

    private var attendance: AttendanceRecord? {
        allAttendance.first(where: { $0.childID == child.id })
    }

    var body: some View {
        VStack(spacing: 0) {
            IOSNavBar(title: child.displayName, onBack: { dismiss() })

            ScrollView {
                VStack(spacing: 24) {
                    IOSCard(title: "Profile") {
                        IOSCardRow(label: "Room", value: child.room)
                        IOSCardRow(
                            label: "Dietary",
                            value: child.dietaryFlags.isEmpty ? "None" : child.dietaryFlags.joined(separator: ", "),
                            showDivider: false
                        )
                    }

                    attendanceCard

                    VStack(spacing: 8) {
                        NavigationLink {
                            DiaryEntryFormView(child: child)
                        } label: {
                            Text("Add diary entry")
                                .font(.system(size: 17, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .frame(height: DesignTokens.buttonHeight)
                                .background(DesignTokens.primary)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous))
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            AttendanceActionView(child: child)
                        } label: {
                            Text("Attendance")
                                .font(.system(size: 17, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .frame(height: DesignTokens.buttonHeight)
                                .background(DesignTokens.card)
                                .foregroundStyle(DesignTokens.primary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous)
                                        .stroke(DesignTokens.primary, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("attendanceNavLink")
                    }

                    diarySection

                    Text(
                        "Only record information needed for care and safeguarding. Avoid unnecessary personal details."
                    )
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(DesignTokens.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
            }
        }
        .background(DesignTokens.background)
        .accessibilityIdentifier("childDetailScreen")
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

    @ViewBuilder
    private var attendanceCard: some View {
        IOSCard(title: "Attendance") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Status")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(DesignTokens.textPrimary)
                    Spacer()
                    IOSStatusChip(status: viewModel.status(for: attendance), large: true)
                }

                Text(attendanceSummaryLine)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(DesignTokens.textSecondary)

                if viewModel.status(for: attendance) == .checkedIn, let dropped = attendance?.droppedBy {
                    Text("Dropped by · \(dropped)")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(DesignTokens.textTertiary)
                }

                if viewModel.status(for: attendance) == .checkedOut,
                   let collected = attendance?.collectedBy,
                   let rel = attendance?.collectorRelationship {
                    Text("Collected by · \(collected) (\(rel))")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(DesignTokens.textTertiary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }

    private var attendanceSummaryLine: String {
        let s = viewModel.status(for: attendance)
        switch s {
        case .notCheckedIn:
            return "Not checked in yet."
        case .checkedIn:
            if let t = NurseryFormatters.shortTime(attendance?.checkInTime) {
                return "Checked in · \(t)"
            }
            return "Checked in"
        case .checkedOut:
            if let t = NurseryFormatters.shortTime(attendance?.checkOutTime) {
                return "Checked out · \(t)"
            }
            return "Checked out"
        }
    }

    @ViewBuilder
    private var diarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Diary today")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(DesignTokens.textTertiary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                Spacer()
                if !diaryEntriesToday.isEmpty {
                    Text("\(diaryEntriesToday.count) \(diaryEntriesToday.count == 1 ? "entry" : "entries")")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(DesignTokens.textTertiary)
                }
            }
            .padding(.horizontal, 4)

            if diaryEntriesToday.isEmpty {
                VStack(spacing: 6) {
                    Text("No entries yet")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(DesignTokens.textTertiary)
                    Text("Log meals, sleep, and wellbeing notes.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(DesignTokens.textQuaternary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(DesignTokens.card)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous))
                .shadow(color: .black.opacity(DesignTokens.shadowOpacity), radius: 4, x: 0, y: 2)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(diaryEntriesToday.enumerated()), id: \.element.id) { index, entry in
                        diaryRow(entry: entry, showDivider: index < diaryEntriesToday.count - 1)
                    }
                }
                .background(DesignTokens.card)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous))
                .shadow(color: .black.opacity(DesignTokens.shadowOpacity), radius: 4, x: 0, y: 2)
            }
        }
    }

    private func diaryRow(entry: DiaryEntry, showDivider: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(DesignTokens.diaryIconBackground)
                        .frame(width: 40, height: 40)
                    Image(systemName: entry.entryType.symbolName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(DesignTokens.primary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(entry.entryType.title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(DesignTokens.textPrimary)
                        Spacer()
                        if let t = NurseryFormatters.shortTime(entry.timestamp) {
                            Text(t)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundStyle(DesignTokens.textTertiary)
                        }
                    }
                    Text(entry.payload)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(DesignTokens.textSecondary)
                        .lineLimit(2)
                }
            }
            .padding(16)

            if showDivider {
                Rectangle()
                    .fill(DesignTokens.border)
                    .frame(height: 1)
                    .padding(.leading, 16 + 40 + 12)
            }
        }
    }
}
