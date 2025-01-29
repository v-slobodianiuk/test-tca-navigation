//
//  TestPresentTCAUITests.swift
//  TestPresentTCAUITests
//
//  Created by Vadym Slobodianiuk on 29.01.2025.
//

import XCTest

final class TestPresentTCAUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testPresentations() throws {
        let buttonOnRootFeature = app.buttons["Show A"]
        let buttonOnAFeature = app.buttons["Show B"]
        let buttonOnBFeature = app.buttons["Close and show C"]
        let buttonOnCFeature = app.buttons["Close"]
        
        // Present AFeature
        XCTAssertTrue(buttonOnRootFeature.exists)
        buttonOnRootFeature.tap()
        
        // Present BFeature on AFeature
        XCTAssertTrue(buttonOnAFeature.exists)
        buttonOnAFeature.tap()
        
        // Dismiss BFeature and present CFeature on AFeture
        XCTAssertTrue(buttonOnBFeature.exists)
        buttonOnBFeature.tap()

        // Wait for presenting CFeature
        XCTAssertTrue(buttonOnCFeature.waitForExistence(timeout: 3), "FeatureC not present")
    }
}
