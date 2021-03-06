//
//  UITestCase.swift
//  SaldoEMTUITests
//
//  Created by Andrés Pizá Bückmann on 19/11/2017.
//  Copyright © 2017 tovkal. All rights reserved.
//

import XCTest

class UITestCase: XCTestCase {
    let app = XCUIApplication()

    let searchQuery = "Fanta"
    let cellProductName = "Fanta Orange"

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchEnvironment["-isUITest"] = "true"
        app.launch()

        // Close "InitialMoney" view
        if app.staticTexts["Enter your current balance:"].exists {
            app.buttons["Cancel"].tap()
        }
    }

    override func tearDown() {
        super.tearDown()
        app.terminate()
    }

    func waitForElementToAppear(_ element: XCUIElement, file: String = #file, line: UInt = #line) {
        _ = app.staticTexts.count // force cached accessibility hierarchy refresh
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: 10) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 5 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }
}
