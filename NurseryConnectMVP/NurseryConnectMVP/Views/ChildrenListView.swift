import SwiftUI
import SwiftData

struct ChildrenListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Child.displayName) private var children: [Child]
    @Query private var attendanceRecords: [AttendanceRecord]

    @StateObject private var viewModel = ChildrenViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                IOSNavBar(title: "My Children", largeTitle: true)

                if children.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Text("No children assigned")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(DesignTokens.textPrimary)
                        Text("Ask your manager to assign key children.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(DesignTokens.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(children, id: \.id) { child in
                                NavigationLink(value: child.id) {
                                    childRow(child: child)
                                        .accessibilityElement(children: .combine)
                                        .accessibilityIdentifier("childRow")
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 24)
                    }
                }
            }
            .background(DesignTokens.background)
            .accessibilityIdentifier("childrenListScreen")
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: UUID.self) { childID in
                if let child = children.first(where: { $0.id == childID }) {
                    ChildDetailView(child: child)
                }
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
    }

    @ViewBuilder
    private func childRow(child: Child) -> some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [DesignTokens.primary, DesignTokens.primaryLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                Text(child.displayName.displayInitials())
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(child.displayName)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(DesignTokens.textPrimary)
                Text("Room: \(child.room)")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(DesignTokens.textSecondary)

                if !child.dietaryFlags.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(child.dietaryFlags, id: \.self) { diet in
                            Text(diet)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(DesignTokens.dietaryPillForeground)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(DesignTokens.dietaryPillBackground)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            IOSStatusChip(status: viewModel.status(for: attendance(for: child.id)))
        }
        .padding(16)
        .background(DesignTokens.card)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cornerRadius, style: .continuous))
        .shadow(color: .black.opacity(DesignTokens.shadowOpacity), radius: 4, x: 0, y: 2)
    }

    private func attendance(for childID: UUID) -> AttendanceRecord? {
        attendanceRecords.first(where: { $0.childID == childID })
    }
}
