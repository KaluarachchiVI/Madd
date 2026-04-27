import XCTest
@testable import NurseryConnectMVP

final class NurseryConnectMVPTests: XCTestCase {
    func testDiaryValidatorRejectsEmptyPayload() {
        XCTAssertThrowsError(try DiaryValidator.validate(payload: "  ")) { error in
            XCTAssertEqual(error as? ValidationError, .diaryNotesEmpty)
        }
    }

    func testAttendanceValidatorRejectsCheckoutBeforeCheckIn() {
        XCTAssertThrowsError(
            try AttendanceValidator.validateCheckOut(
                collectedBy: "Aunt Maya",
                relationship: "Aunt",
                checkInTime: nil
            )
        ) { error in
            XCTAssertEqual(
                error as? ValidationError,
                .invalidTransition("Cannot check out. Child must be checked in first.")
            )
        }
    }

    func testAttendanceValidatorRejectsOutOfOrderTimes() {
        let later = Date()
        let earlier = later.addingTimeInterval(-3600)

        XCTAssertThrowsError(
            try AttendanceValidator.validateDateOrder(checkInTime: later, checkOutTime: earlier)
        ) { error in
            XCTAssertEqual(
                error as? ValidationError,
                .invalidDate("Check-out time cannot be earlier than check-in time")
            )
        }
    }
}
