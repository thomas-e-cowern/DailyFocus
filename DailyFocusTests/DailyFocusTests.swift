//
//  DailyFocusTests.swift
//  DailyFocusTests
//
//  Created by Thomas Cowern New on 7/20/22.
//

import CoreData
import XCTest
@testable import DailyFocus

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
