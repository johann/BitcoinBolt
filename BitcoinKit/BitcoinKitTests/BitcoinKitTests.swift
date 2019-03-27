//
//  BitcoinKitTests.swift
//  BitcoinKitTests
//
//  Created by Johann Kerr on 3/24/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import XCTest
@testable import BitcoinKit

class BitcoinKitTests: XCTestCase {

    func testGetCurrentPrice() {
        class WebServiceMock: WebService {
            override func request(url: URL, completion: @escaping (Data?, Error?) -> ()) {
                let json = """
                    {
                        "time": {
                            "updated": "Mar 27, 2019 02:40:00 UTC",
                            "updatedISO": "2019-03-27T02:40:00+00:00",
                            "updateduk": "Mar 27, 2019 at 02:40 GMT"
                        },
                    "disclaimer": "This data was produced from the CoinDesk Bitcoin Price Index (USD). Non-USD currency data converted using hourly conversion rate from openexchangerates.org",
                    "bpi": {
                        "USD": {
                                "code": "USD",
                                "rate": "3,996.5683",
                                "description": "United States Dollar",
                                "rate_float": 3996.5683
                            },
                        "EUR": {
                                "code": "EUR",
                                "rate": "3,031.5410",
                                "description": "Euro",
                                "rate_float": 3031.541
                            }
                        }
                    }
                """
                
                let data = Data(json.utf8)
                completion(data, nil)
            }
        }
        
        var price: CurrentPrice!
        BitcoinClient(service: WebServiceMock()).getCurrentPrice { (currentPrice) in
            guard let currentPrice = currentPrice else { return }
            price = currentPrice
        }
       
        XCTAssertEqual(price.eurPrice.code, "EUR")
        XCTAssertEqual(price.eurPrice.rate_float, 3031.541)
        XCTAssertEqual(price.eurPrice.rate, "3,031.5410")
    }
    
    func testGetHistoricalLists() {
        class WebServiceMock: WebService {
            override func request(url: URL, completion: @escaping (Data?, Error?) -> ()) {
                let json = """
                    {
                        "bpi": {
                            "2019-02-24": 3767.305,
                            "2019-02-25": 3852.16,
                            "2019-02-26": 3830.6733,
                            "2019-02-27": 3832.26,
                            },
                        "disclaimer": "This data was produced from the CoinDesk Bitcoin Price Index. BPI value data returned as USD.",
                        "time": {
                            "updated": "Mar 27, 2019 00:03:00 UTC",
                        }
                    }
                """
                
                let data = Data(json.utf8)
                completion(data, nil)
            }
        }
        
        var prices = [DatePrice]()
        BitcoinClient(service: WebServiceMock()).getHistoricalLists { (datePrices) in
            guard let datePrices = datePrices else { return }
            prices = datePrices
        }
        
        XCTAssertTrue(prices.count > 0, "Client failed")
        XCTAssertEqual(prices.first?.currency, "EUR")
    }

}
