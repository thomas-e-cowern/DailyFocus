//
//  ExtensionTests.swift
//  DailyFocusTests
//
//  Created by Thomas Cowern New on 7/22/22.
//

import XCTest
@testable import DailyFocus

class ExtensionTests: XCTestCase {

    func testSequenceKeyPathSortingSelf() {
        let items = [1, 4, 5, 3, 2]
        let sortedItems = items.sorted(by: \.self)
        XCTAssertEqual(sortedItems, [1, 2, 3, 4, 5], "The sorted numbers must be ascending")
    }
}
