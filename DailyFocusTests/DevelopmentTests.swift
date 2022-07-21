//
//  DevelopmentTests.swift
//  DailyFocusTests
//
//  Created by Thomas Cowern New on 7/21/22.
//

import XCTest
import CoreData
@testable import DailyFocus

class DevelopmentTests: BaseTestCase {

    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 sample projects.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 50, "There should be 50 sample items.")
    }
}
