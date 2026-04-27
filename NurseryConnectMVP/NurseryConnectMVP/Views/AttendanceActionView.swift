import SwiftUI
import SwiftData

struct AttendanceActionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var allAttendance: [AttendanceRecord]
    @StateObject private var viewModel = ChildrenViewModel()

    let child: Child

    @State private var checkInTime = Date()
    @State private var droppedBy = ""
    @State private var checkInNotes = ""

    @State private var checkOutTime = Date()
    @State private var collectedBy = ""
    @State private var relationship = ""
    @State private var checkOutNotes = ""

    @State private var droppedByError: String?
    @State private var collectedByError: String?
    @State private var relationshipError: String?
    @State private var checkOutTimeError: String?
    @State private var showCheckoutBanner = false

    private var attendance: AttendanceRecord? {
        allAttendance.first(where: { $0.childID == child.id })
    }

    private var status: AttendanceStatus {
        viewModel.status(for: attendance)
    }

    var body: some View {
        VStack(spacing: 0) {
            IOSNavBar(title: "Attendance", onBack: { dismiss() })

            ScrollView {
                VStack(spacing: 24) {
                    currentStatusCard

                    if showCheckoutBanner, status != .checkedIn {
                        checkoutBanner
                    }

                    IOSCard(title: "Check in") {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Time")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(DesignTokens.textPrimary)
                                DatePicker("", selection: $checkInTime, displayedComponents: [.hourAndMinute])
                                    .labelsHidden()
                                    .tint(DesignTokens.primary)
                            }

                            IOSFormTextField(
                                label: "Dropped by",
                                text: $droppedBy,
                                placeholder: "Name and relationship, e.g. Maya Fernando (mum)",
                                required: true,
                                helper: "Name and relationship, e.g. Maya Fernando (mum)",
                                error: droppedByError
                            )
                            .onChange(of: droppedBy) { _, newValue in
                                if droppedByError != nil, !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    droppedByError = nil
                                }
                            }

                            IOSFormTextField(
                                label: "Handover notes",
                                text: $checkInNotes,
                                placeholder: "Include allergies handed over, sleep, mood.",
                                multiline: true,
                                lineCount: 3,
                                helper: "Include allergies handed over, sleep, mood."
                            )

                            IOSPrimaryButton(title: "Confirm check-in", disabled: status == .checkedIn) {
                                confirmCheckIn()
                            }
                            .accessibilityIdentifier("confirmCheckInButton")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    }

                    IOSCard(title: "Check out") {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Time")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(DesignTokens.textPrimary)
                                DatePicker("", selection: $checkOutTime, displayedComponents: [.hourAndMinute])
                                    .labelsHidden()
                                    .tint(DesignTokens.primary)
                                if let checkOutTimeError {
                                    Text(checkOutTimeError)
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundStyle(DesignTokens.destructive)
                                }
                            }
                            .onChange(of: checkOutTime) { _, _ in
                                if checkOutTimeError != nil {
                                    checkOutTimeError = nil
                                }
                            }

                            IOSFormTextField(
                                label: "Collected by",
                                text: $collectedBy,
                                placeholder: "Full name",
                                required: true,
                                error: collectedByError
                            )
                            .onChange(of: collectedBy) { _, newValue in
                                if collectedByError != nil, !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    collectedByError = nil
                                }
                            }

                            IOSFormTextField(
                                label: "Relationship to child",
                                text: $relationship,
                                placeholder: "e.g. Aunt / Grandparent / Childminder",
                                required: true,
                                helper: "e.g. Aunt / Grandparent / Childminder",
                                error: relationshipError
                            )
                            .onChange(of: relationship) { _, newValue in
                                if relationshipError != nil, !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    relationshipError = nil
                                }
                            }

                            IOSFormTextField(
                                label: "Handover notes",
                                text: $checkOutNotes,
                                placeholder: "Summary of the day",
                                multiline: true,
                                lineCount: 3
                            )

                            IOSPrimaryButton(title: "Confirm check-out", disabled: status == .checkedOut) {
                                confirmCheckOut()
                            }
                            .accessibilityIdentifier("confirmCheckOutButton")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    }

                    Text(
                        "Only record information needed for care and safeguarding. Avoid unnecessary personal details."
                    )
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(DesignTokens.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
            }
        }
        .background(DesignTokens.background)
        .accessibilityIdentifier("attendanceScreen")
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            syncFromAttendance()
        }
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

    private var currentStatusCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Current status")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(DesignTokens.textPrimary)
                Spacer()
                IOSStatusChip(status: status, large: true)
            }
            Text(statusExplanation)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(DesignTokens.textSecondary)
        }
        .padding(16)
        .background(DesignTokens.card)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous))
        .shadow(color: .black.opacity(DesignTokens.shadowOpacity), radius: 4, x: 0, y: 2)
    }

    private var statusExplanation: String {
        switch status {
        case .notCheckedIn:
            return "Child is not currently checked in."
        case .checkedIn:
            return "Child is currently checked in."
        case .checkedOut:
            return "Child has been checked out today."
        }
    }

    private var checkoutBanner: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 20))
                .foregroundStyle(DesignTokens.destructive)
            Text("Cannot check out. Child must be checked in first.")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(DesignTokens.destructive)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DesignTokens.bannerErrorBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous)
                .stroke(DesignTokens.bannerErrorBorder, lineWidth: 1)
        )
    }

    private func syncFromAttendance() {
        guard let attendance else { return }
        droppedBy = attendance.droppedBy ?? ""
        collectedBy = attendance.collectedBy ?? ""
        relationship = attendance.collectorRelationship ?? ""
        checkInNotes = attendance.checkInNotes ?? ""
        checkOutNotes = attendance.checkOutNotes ?? ""
        if let t = attendance.checkInTime { checkInTime = t }
        if let t = attendance.checkOutTime { checkOutTime = t }
    }

    private func confirmCheckIn() {
        do {
            try AttendanceValidator.validateCheckIn(droppedBy: droppedBy)
            droppedByError = nil
        } catch {
            droppedByError = error.localizedDescription
            return
        }

        guard let attendance else { return }
        viewModel.checkIn(
            context: modelContext,
            attendance: attendance,
            time: checkInTime,
            droppedBy: droppedBy,
            notes: checkInNotes
        )
        if viewModel.errorMessage == nil {
            showCheckoutBanner = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                dismiss()
            }
        }
    }

    private func confirmCheckOut() {
        if status != .checkedIn {
            showCheckoutBanner = true
            return
        }

        collectedByError = nil
        relationshipError = nil
        checkOutTimeError = nil

        do {
            try AttendanceValidator.validateCheckOut(
                collectedBy: collectedBy,
                relationship: relationship,
                checkInTime: attendance?.checkInTime
            )
            try AttendanceValidator.validateDateOrder(
                checkInTime: attendance?.checkInTime,
                checkOutTime: checkOutTime
            )
        } catch let err as ValidationError {
            switch err {
            case .attendanceCollectedByEmpty:
                collectedByError = err.localizedDescription
            case .attendanceRelationshipEmpty:
                relationshipError = err.localizedDescription
            case .invalidDate(let message):
                checkOutTimeError = message
            default:
                viewModel.errorMessage = err.localizedDescription
            }
            return
        } catch {
            return
        }

        guard let attendance else { return }
        viewModel.checkOut(
            context: modelContext,
            attendance: attendance,
            time: checkOutTime,
            collectedBy: collectedBy,
            relationship: relationship,
            notes: checkOutNotes
        )
        if viewModel.errorMessage == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                dismiss()
            }
        }
    }
}
