// MainScreenTests.swift
// Copyright © RoadMap. All rights reserved.

//
//  MainScreen.swift
//  MooviesUITests
//
//  Created by Vera Zaitseva on 08.10.2021.
//
import Foundation
import XCTest

class MainScreenTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSegmentControl() throws {
        let app = XCUIApplication()
        app.segmentedControls.buttons["Популярные"].tap()
        app.segmentedControls.buttons["Топ-100"].tap()
        app.segmentedControls.buttons["Скоро"].tap()

        if app.segmentedControls.buttons["Популярные"].isSelected {
            XCTAssertTrue(app.segmentedControls.buttons["Скоро"].isSelected != true)
            XCTAssertFalse(app.segmentedControls.buttons["Скоро"].isSelected == true)
        }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
