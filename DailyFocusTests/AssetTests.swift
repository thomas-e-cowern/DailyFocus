//
//  XCTestCase.swift
//  DailyFocusTests
//
//  Created by Thomas Cowern New on 7/20/22.
//

import XCTest
@testable import DailyFocus

class AssetTests: XCTestCase {
    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
        }
    }

    func testJsonLoadsCorrectly() {
        XCTAssertTrue(Award.allAwards.isEmpty == false, "Failed to load awards from JSON.")
    }
}
