//
//  DailyFocusUITests.swift
//  DailyFocusUITests
//
//  Created by Thomas Cowern New on 7/27/22.
//

import XCTest

class DailyFocusUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true

        // In UI tests it’s important to set the initial state - such as interface orientation -
        // required for your tests before they run. The setUp method is a good place to do this.
    }

    func testAppHas4Tabs() throws {

        let app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in the app")
    }

    func testOpenTabAddsProjects() {

        let app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        for tapCount in 1...5 {
            app.buttons["Add Project"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) rows(s) in the list.")
        }
    }
}
