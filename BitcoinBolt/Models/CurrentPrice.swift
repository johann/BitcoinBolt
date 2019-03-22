//
//  CurrentPrice.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/20/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation

enum TopLevelCodingKeys: String, CodingKey { case time, bpi }

struct CurrentPrice: Decodable {
    var eurPrice: Price
    var usPrice: Price
    var updatedAt: Date?
    
    
    enum TimeCodingKeys: String, CodingKey { case updated, updateduk, updatedISO }
    enum CurrencyKeys: String, CodingKey { case USD, EUR }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TopLevelCodingKeys.self)
        let timeContainer = try container.nestedContainer(keyedBy: TimeCodingKeys.self, forKey: .time)
        let dateString = try timeContainer.decode(String.self, forKey: .updatedISO)
        
        let dateformatter = ISO8601DateFormatter()
        self.updatedAt = dateformatter.date(from: dateString)
        
        let currencyContainer = try container.nestedContainer(keyedBy: CurrencyKeys.self, forKey: .bpi)
        self.eurPrice = try currencyContainer.decode(Price.self, forKey: .EUR)
        self.usPrice = try currencyContainer.decode(Price.self, forKey: .USD)
    }
    
    static func parse(_ data: Data) -> CurrentPrice  {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try! JSONDecoder().decode(CurrentPrice.self, from: data)
    }
}

