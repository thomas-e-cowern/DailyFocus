//
//  ExtensionTests.swift
//  DailyFocusTests
//
//  Created by Thomas Cowern New on 7/22/22.
//

import XCTest
@testable import DailyFocus

class ExtensionTests: XCTestCase {

    func testBundleDecodingAwards() {
        let awards = Bundle.main.decode([Award].self, from: "Awards.json")
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode to a non-empty array.")
    }
}
