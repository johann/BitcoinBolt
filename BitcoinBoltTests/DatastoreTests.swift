//
//  DatastoreTests.swift
//  BitcoinBoltTests
//
//  Created by Johann Kerr on 3/27/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import XCTest
@testable import BitcoinBolt
@testable import BitcoinKit

class DatastoreTests: XCTestCase {
    var store: DataStore!
    
    override func setUp() {
        super.setUp()
        store = DataStore.shared
    }

    override func tearDown() {
        store = nil
        super.tearDown()
    }
    
    func testFetchCurrentPrice() {
        class ClientMock: BitcoinClient {
            override func getCurrentPrice(currency: Currency = .EUR, result: @escaping BitcoinClient.CurrentPriceHandler) {
                let eurPrice = Price(code: "EUR", rate: "300", rate_float: 300.0)
                let usdPrice = Price(code: "USD", rate: "301", rate_float: 301.0)
                let currentPrice = CurrentPrice(eurPrice: eurPrice, usPrice: usdPrice, updatedAt: Date())
                result(.success(currentPrice))
            }
        }
       
        store.fetchCurrentPrice(client: ClientMock()) {
            let price = self.store.currentPrice?.eurPrice
            XCTAssertEqual(price?.code, "EUR")
            XCTAssertEqual(price?.rate, "300")
            XCTAssertEqual(price?.rate_float, 300.0)
        }
    }
    
    func testFetchPastPrices() {
        class ClientMock: BitcoinClient {
            func datePriceFactory() -> [DatePrice] {
                var prices = [DatePrice]()
                for _ in 1...10 {
                    let price = Int(arc4random_uniform(100))
                    prices.append(DatePrice(date: "2019-02-24", currency: "EUR", price: Double(price)))
                }
                return prices
                
            }
            
            override func getHistoricalLists(currency: Currency = .EUR, result: @escaping BitcoinClient.DatePriceHandler) {
                result(.success(datePriceFactory()))
            }
        }
        
        store.fetchPastPrices(client: ClientMock()) {
            guard let eurPrices = self.store.pricesByCurrency[.EUR] else { XCTFail(); return }
            XCTAssertTrue(eurPrices.count > 0)
        }
    }


}
