//
//  ExtensionTests.swift
//  DailyFocusTests
//
//  Created by Thomas Cowern New on 7/22/22.
//

import XCTest
@testable import DailyFocus

class ExtensionTests: XCTestCase {

    let correctString = "This string is to test if this project can load simple json"

    func testBundleDecodingAwards() {
        let awards = Bundle.main.decode([Award].self, from: "Awards.json")
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode to a non-empty array.")
    }

    func testDecodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode(String.self, from: "DecodableString.json")
        XCTAssertEqual(data, correctString, "The string must match the content of DecodableString.json.")
    }
}
