import Foundation
import SwiftData

@MainActor
final class ChildrenViewModel: ObservableObject {
    @Published var errorMessage: String?

    func status(for attendance: AttendanceRecord?) -> AttendanceStatus {
        guard let attendance else { return .notCheckedIn }
        if attendance.checkOutTime != nil { return .checkedOut }
        if attendance.checkInTime != nil { return .checkedIn }
        return .notCheckedIn
    }

    func addDiaryEntry(
        context: ModelContext,
        child: Child,
        type: DiaryEntryType,
        timestamp: Date,
        payload: String,
        isSignificant: Bool
    ) {
        do {
            try DiaryValidator.validate(payload: payload)
            let entry = DiaryEntry(
                childID: child.id,
                entryType: type,
                timestamp: timestamp,
                payload: payload,
                isSignificantUpdate: isSignificant
            )
            context.insert(entry)
            try context.save()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func checkIn(
        context: ModelContext,
        attendance: AttendanceRecord,
        time: Date,
        droppedBy: String,
        notes: String
    ) {
        do {
            try AttendanceValidator.validateCheckIn(droppedBy: droppedBy)

            if attendance.checkInTime != nil && attendance.checkOutTime == nil {
                throw ValidationError.invalidTransition("Child is already checked in.")
            }

            attendance.checkInTime = time
            attendance.checkOutTime = nil
            attendance.droppedBy = droppedBy
            attendance.collectedBy = nil
            attendance.collectorRelationship = nil
            attendance.checkInNotes = notes
            attendance.checkOutNotes = nil

            try context.save()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func checkOut(
        context: ModelContext,
        attendance: AttendanceRecord,
        time: Date,
        collectedBy: String,
        relationship: String,
        notes: String
    ) {
        do {
            try AttendanceValidator.validateCheckOut(
                collectedBy: collectedBy,
                relationship: relationship,
                checkInTime: attendance.checkInTime
            )
            try AttendanceValidator.validateDateOrder(
                checkInTime: attendance.checkInTime,
                checkOutTime: time
            )

            if attendance.checkOutTime != nil {
                throw ValidationError.invalidTransition("Child is already checked out.")
            }

            attendance.checkOutTime = time
            attendance.collectedBy = collectedBy
            attendance.collectorRelationship = relationship
            attendance.checkOutNotes = notes

            try context.save()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
