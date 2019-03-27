//
//  Price.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/20/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation

public struct Price: Codable {
    public var code: String
    public var rate: String
    public var rate_float: Double
    public var priceWithCurrencyCode: String {
        get {
            return self.rate_float.currencyFormat(code: self.code) ?? ""
        }
    }
    
    
    
}
public struct DatePrice: Codable {
    public var date: String
    public var currency: String
    public var price: Double
    public var dateValue: Date {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: self.date)!
        }
    }
    
    public var priceWithCurrencyCode: String {
        get {
           return self.price.currencyFormat(code: self.currency)!
        }
    }
    
    public init (date: String, currency: String, price: Double) {
        self.date = date
        self.currency = currency
        self.price = price
    }
}

extension DatePrice: Hashable {
    public var hashValue: Int {
        return date.hashValue ^ price.hashValue ^ currency.hashValue
    }
}

