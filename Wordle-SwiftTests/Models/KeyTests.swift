//
//  KeyTests.swift
//  ©️ 2023 0100
//

import XCTest
@testable import Wordle_Swift

final class KeyTests: XCTestCase {

    func testKeyInit() throws {
        XCTAssertEqual(Key(rawValue: "A")?.rawValue, "A", "Key should be initialized with uppercased rawValue")
        XCTAssertEqual(Key(rawValue: "a")?.rawValue, "A", "Key should be initialized with uppercased rawValue")
        XCTAssertNil(Key(rawValue: "0")?.rawValue, "Key initialization requires valid case")
    }
    
    func testKeyEquality() throws {
        XCTAssertEqual(Key.A.rawValue, "A", "Key Equality should pass on uppercase")
        XCTAssertNotEqual(Key.A.rawValue, "a", "Key Equality should fail on lowercase")
    }
}
