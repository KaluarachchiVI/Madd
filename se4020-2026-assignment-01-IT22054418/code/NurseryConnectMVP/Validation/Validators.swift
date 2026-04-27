import Foundation

enum ValidationError: LocalizedError, Equatable {
    case emptyField(String)
    case diaryNotesEmpty
    case invalidTransition(String)
    case invalidDate(String)
    case attendanceDroppedByEmpty
    case attendanceCollectedByEmpty
    case attendanceRelationshipEmpty

    var errorDescription: String? {
        switch self {
        case .emptyField(let field):
            return "\(field) is required."
        case .diaryNotesEmpty:
            return "Please add notes about what happened"
        case .invalidTransition(let message):
            return message
        case .invalidDate(let message):
            return message
        case .attendanceDroppedByEmpty:
            return "Please enter who dropped off the child"
        case .attendanceCollectedByEmpty:
            return "Please enter who collected the child"
        case .attendanceRelationshipEmpty:
            return "Please enter relationship to child"
        }
    }
}

enum DiaryValidator {
    static func validate(payload: String) throws {
        if payload.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw ValidationError.diaryNotesEmpty
        }
    }
}

enum AttendanceValidator {
    static func validateCheckIn(droppedBy: String) throws {
        if droppedBy.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw ValidationError.attendanceDroppedByEmpty
        }
    }

    static func validateCheckOut(collectedBy: String, relationship: String, checkInTime: Date?) throws {
        if checkInTime == nil {
            throw ValidationError.invalidTransition("Cannot check out. Child must be checked in first.")
        }

        if collectedBy.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw ValidationError.attendanceCollectedByEmpty
        }

        if relationship.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw ValidationError.attendanceRelationshipEmpty
        }
    }

    static func validateDateOrder(checkInTime: Date?, checkOutTime: Date?) throws {
        guard let inTime = checkInTime, let outTime = checkOutTime else { return }
        if outTime < inTime {
            throw ValidationError.invalidDate("Check-out time cannot be earlier than check-in time")
        }
    }
}
