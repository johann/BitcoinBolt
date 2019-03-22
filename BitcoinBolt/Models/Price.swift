//
//  Price.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/20/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation

struct Price: Decodable {
    var code: String
    var rate: String
    var rate_float: Double
}

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
    
}
