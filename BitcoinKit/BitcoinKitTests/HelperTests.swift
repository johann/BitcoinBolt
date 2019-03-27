//
//  DoubleExtensionTests.swift
//  BitcoinKitTests
//
//  Created by Johann Kerr on 3/26/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import XCTest
@testable import BitcoinKit

class HelperTests: XCTestCase {
    
    
    func testDateHelpers() {
        let date = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(date.monthAsString(), "Dec")
        XCTAssertEqual(date.weekday(), 31)
    }
    
    func testCurrencyFormat() {
        let double: Double = 100.0
        guard let output = double.currencyFormat(code: "EUR") else { return }
        XCTAssertEqual(output, "€100.00")
    }
}
