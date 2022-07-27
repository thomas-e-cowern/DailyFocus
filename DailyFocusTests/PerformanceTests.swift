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
        try dataController.createSampleData()
        let awards = Award.allAwards

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }

}
