//
//  Price.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/20/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation

protocol CurrencyCodable {}
struct Price: Decodable {
    var code: String
    var rate: String
    var rate_float: Double
    var priceWithCurrencyCode: String {
        get {
            return self.rate_float.currencyFormat(code: Currency(rawValue: code) ?? .EUR)!
        }
    }
    
}
// TODO: Fix later
struct DatePrice {
    var date: String
    var price: Double
    var currency: Currency
    var dateValue: Date {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: self.date)!
        }
    }
    
    var priceWithCurrencyCode: String {
        get {
           return self.price.currencyFormat(code: self.currency)!
        }
    }
    
}

extension DatePrice: Hashable {
    var hashValue: Int {
        return date.hashValue ^ price.hashValue ^ currency.hashValue
    }
}

