import Foundation
import SwiftData

enum DiaryEntryType: String, Codable, CaseIterable, Identifiable {
    case activity
    case sleep
    case meal
    case nappy
    case wellbeing

    var id: String { rawValue }

    var title: String {
        switch self {
        case .activity: return "Activity"
        case .sleep: return "Sleep/Nap"
        case .meal: return "Meal/Fluid"
        case .nappy: return "Nappy/Toilet"
        case .wellbeing: return "Wellbeing"
        }
    }

    /// Short labels for horizontal type chips (matches `AddDiaryEntryScreen.tsx`).
    var chipTitle: String {
        switch self {
        case .activity: return "Activity"
        case .sleep: return "Sleep"
        case .meal: return "Meal"
        case .nappy: return "Nappy"
        case .wellbeing: return "Wellbeing"
        }
    }

    var symbolName: String {
        switch self {
        case .activity: return "figure.run"
        case .sleep: return "moon.zzz.fill"
        case .meal: return "fork.knife"
        case .nappy: return "figure.child"
        case .wellbeing: return "heart.fill"
        }
    }
}

enum AttendanceStatus: String {
    case notCheckedIn
    case checkedIn
    case checkedOut
}

@Model
final class Child {
    @Attribute(.unique) var id: UUID
    var displayName: String
    var room: String
    var dietaryFlags: [String]

    init(
        id: UUID = UUID(),
        displayName: String,
        room: String,
        dietaryFlags: [String] = []
    ) {
        self.id = id
        self.displayName = displayName
        self.room = room
        self.dietaryFlags = dietaryFlags
    }
}

@Model
final class DiaryEntry {
    @Attribute(.unique) var id: UUID
    var childID: UUID
    var entryTypeRaw: String
    var timestamp: Date
    var payload: String
    var createdByRole: String
    var isSignificantUpdate: Bool

    var entryType: DiaryEntryType {
        get { DiaryEntryType(rawValue: entryTypeRaw) ?? .activity }
        set { entryTypeRaw = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        childID: UUID,
        entryType: DiaryEntryType,
        timestamp: Date,
        payload: String,
        createdByRole: String = "Keyworker",
        isSignificantUpdate: Bool = true
    ) {
        self.id = id
        self.childID = childID
        self.entryTypeRaw = entryType.rawValue
        self.timestamp = timestamp
        self.payload = payload
        self.createdByRole = createdByRole
        self.isSignificantUpdate = isSignificantUpdate
    }
}

@Model
final class AttendanceRecord {
    @Attribute(.unique) var id: UUID
    var childID: UUID
    var checkInTime: Date?
    var droppedBy: String?
    var checkOutTime: Date?
    var collectedBy: String?
    var collectorRelationship: String?
    var checkInNotes: String?
    var checkOutNotes: String?

    init(
        id: UUID = UUID(),
        childID: UUID,
        checkInTime: Date? = nil,
        droppedBy: String? = nil,
        checkOutTime: Date? = nil,
        collectedBy: String? = nil,
        collectorRelationship: String? = nil,
        checkInNotes: String? = nil,
        checkOutNotes: String? = nil
    ) {
        self.id = id
        self.childID = childID
        self.checkInTime = checkInTime
        self.droppedBy = droppedBy
        self.checkOutTime = checkOutTime
        self.collectedBy = collectedBy
        self.collectorRelationship = collectorRelationship
        self.checkInNotes = checkInNotes
        self.checkOutNotes = checkOutNotes
    }
}

enum SeedDataLoader {
    static func seedIfNeeded(context: ModelContext) {
        var descriptor = FetchDescriptor<Child>()
        descriptor.fetchLimit = 1

        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }

        let children = [
            Child(displayName: "Aarav Perera", room: "Butterflies", dietaryFlags: ["Nut-free"]),
            Child(displayName: "Mia Fernando", room: "Ladybirds", dietaryFlags: ["Dairy-free"]),
            Child(displayName: "Noah Silva", room: "Butterflies")
        ]

        for child in children {
            context.insert(child)
            let attendance = AttendanceRecord(childID: child.id)
            context.insert(attendance)
        }

        try? context.save()
    }
}
