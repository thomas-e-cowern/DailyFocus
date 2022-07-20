//
//  ProjectTests.swift
//  DailyFocusTests
//
//  Created by Thomas Cowern New on 7/20/22.
//

import XCTest
import CoreData
@testable import DailyFocus

class ProjectTests: BaseTestCase {
    func testCreatingProjectsAndItems() {
        let targetCount = 10

        for _ in 0..<targetCount {
            let project = Project(context: managedObjectContext)

            for _ in 0..<targetCount {
                let item = Item(context: managedObjectContext)
                item.project = project
            }
        }

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), targetCount * targetCount)
    }
}
