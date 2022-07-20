//
//  AwardsTests.swift
//  DailyFocusTests
//
//  Created by Thomas Cowern New on 7/20/22.
//

import XCTest
import CoreData
@testable import DailyFocus

class AwardsTests: BaseTestCase {

    let awards = Award.allAwards

    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should always match its name.")
        }
    }

    func testNoAwards() throws {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "New users should have no earned awards")
        }
    }

}
