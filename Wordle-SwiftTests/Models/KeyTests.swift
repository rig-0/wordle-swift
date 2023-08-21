//
//  KeyTests.swift
//  ©️ 2023 0100
//

import XCTest
@testable import Wordle_Swift

final class KeyTests: XCTestCase {

    func testKeyEquality() throws {
        XCTAssertEqual(Key.A.rawValue, "A", "Key Equality should pass on uppercase")
        XCTAssertNotEqual(Key.A.rawValue, "a", "Key Equality should fail on lowercase")
    }
}
