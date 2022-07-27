//
//  PerformanceTests.swift
//  DailyFocusTests
//
//  Created by Thomas Cowern New on 7/27/22.
//

import XCTest
import CoreData
@testable import DailyFocus

class PerformanceTests: BaseTestCase {

    func testAwardCalculationPerformance() throws {

        // Create a large amount of test data
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        // Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks the number of awards is constant. Change if new awards added")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }

}
