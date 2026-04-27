import XCTest

final class NurseryConnectMVPUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testChildrenListLoads() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.otherElements["childrenListScreen"].waitForExistence(timeout: 3))
    }

    func testNavigateToAttendance() {
        let app = XCUIApplication()
        app.launch()

        let firstRow = app.buttons.matching(identifier: "childRow").element(boundBy: 0)
        XCTAssertTrue(firstRow.waitForExistence(timeout: 3))
        firstRow.tap()

        app.buttons["Attendance"].firstMatch.tap()
        XCTAssertTrue(app.otherElements["attendanceScreen"].waitForExistence(timeout: 3))
    }
}
