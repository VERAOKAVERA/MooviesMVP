// DescriptionScreenTests.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import XCTest

class DescriptionScrennTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testWatchDescription() throws {}
}
