//
//  Wordle_SwiftUITests.swift
//  Wordle-SwiftUITests
//
//  Created by RIGO CARBAJAL on 8/11/23.
//

import XCTest

final class Wordle_SwiftUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app.launchArguments += ["UI-TESTING"]
        app.launchEnvironment["correctWord"] = "APPLE"
        app.launch()
    }

    private func element(key: Key) -> XCUIElement {
        return app.otherElements.element(matching: .other, identifier: "Key_" + key.rawValue)
    }
    
    func testMagnificentSolve() throws {
        
        // Wait for keyboard to appear
        guard element(key: .A).waitForExistence(timeout: 1) else {
            XCTFail()
            return
        }
        
        // Tap keys for solve word and press ENTER
        element(key: .A).tap()
        element(key: .P).tap()
        element(key: .P).tap()
        element(key: .L).tap()
        element(key: .E).tap()
        element(key: .ENTER).tap()
        
        // Wait for Magnificent toast to appear
        let expectation = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.staticTexts["Magnificent"],
            handler: .none
        )

        let result = XCTWaiter.wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(result, .completed)
    }
    
    func testImpressiveSolve() throws {
        
        // Wait for keyboard to appear
        guard element(key: .A).waitForExistence(timeout: 1) else {
            XCTFail()
            return
        }
        
        element(key: .P).tap()
        element(key: .A).tap()
        element(key: .P).tap()
        element(key: .E).tap()
        element(key: .R).tap()
        element(key: .ENTER).tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        element(key: .A).tap()
        element(key: .P).tap()
        element(key: .P).tap()
        element(key: .L).tap()
        element(key: .E).tap()
        element(key: .ENTER).tap()
        
        // Wait for Magnificent toast to appear
        let expectation = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.staticTexts["Impressive"],
            handler: .none
        )

        let result = XCTWaiter.wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(result, .completed)
    }
    
    func testPhewSolve() throws {
        
        // Wait for keyboard to appear
        guard element(key: .A).waitForExistence(timeout: 1) else {
            XCTFail()
            return
        }
        
        // Tap keys for solve word and press ENTER
        element(key: .A).tap()
        element(key: .M).tap()
        element(key: .P).tap()
        element(key: .L).tap()
        element(key: .E).tap()
        element(key: .ENTER).tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        element(key: .H).tap()
        element(key: .I).tap()
        element(key: .P).tap()
        element(key: .P).tap()
        element(key: .O).tap()
        element(key: .ENTER).tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        element(key: .A).tap()
        element(key: .P).tap()
        element(key: .P).tap()
        element(key: .L).tap()
        element(key: .Y).tap()
        element(key: .ENTER).tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        element(key: .T).tap()
        element(key: .U).tap()
        element(key: .P).tap()
        element(key: .L).tap()
        element(key: .E).tap()
        element(key: .ENTER).tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        element(key: .P).tap()
        element(key: .O).tap()
        element(key: .P).tap()
        element(key: .P).tap()
        element(key: .Y).tap()
        element(key: .ENTER).tap()
        
        Thread.sleep(forTimeInterval: 1)
        
        element(key: .A).tap()
        element(key: .P).tap()
        element(key: .P).tap()
        element(key: .L).tap()
        element(key: .E).tap()
        element(key: .ENTER).tap()
        
        // Wait for Magnificent toast to appear
        let expectation = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.staticTexts["Phew"],
            handler: .none
        )

        let result = XCTWaiter.wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(result, .completed)
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
