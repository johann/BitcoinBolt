//
//  CurrentPrice.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/20/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation

public enum TopLevelCodingKeys: String, CodingKey { case time, bpi }

public struct CurrentPrice {
    public var eurPrice: Price
    public var usPrice: Price
    public var updatedAt: Date?
    
    static func parse(_ data: Data) -> CurrentPrice  {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try! JSONDecoder().decode(CurrentPrice.self, from: data)
    }
    
    public init(eurPrice: Price, usPrice: Price, updatedAt: Date?) {
        self.eurPrice = eurPrice
        self.usPrice = usPrice
        self.updatedAt = updatedAt
    }
}

extension CurrentPrice: Decodable {
    enum TimeCodingKeys: String, CodingKey { case updated, updateduk, updatedISO }
    enum CurrencyKeys: String, CodingKey { case USD, EUR }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TopLevelCodingKeys.self)
        let timeContainer = try container.nestedContainer(keyedBy: TimeCodingKeys.self, forKey: .time)
        let dateString = try timeContainer.decode(String.self, forKey: .updatedISO)
        
        let dateformatter = ISO8601DateFormatter()
        self.updatedAt = dateformatter.date(from: dateString)
        
        let currencyContainer = try container.nestedContainer(keyedBy: CurrencyKeys.self, forKey: .bpi)
        self.eurPrice = try currencyContainer.decode(Price.self, forKey: .EUR)
        self.usPrice = try currencyContainer.decode(Price.self, forKey: .USD)
    }
}

