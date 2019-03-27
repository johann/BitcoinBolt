//
//  Datastore.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/21/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation
import CoreData
import BitcoinKit

typealias Handler = () -> ()

final class DataStore {
    private init () {}
    static let shared = DataStore()
    
    var currentPrice: CurrentPrice?
    var currentPriceByCurrency: [Currency: DatePrice] = [:]
    var pricesByCurrency: [Currency: [DatePrice]] = [:]
    var homeTimer: Timer?
    var errors = [Error]()
    
    func fetchCurrentPriceAtInterval(_ timeInterval: TimeInterval = Constants.refreshRate, completion: @escaping Handler) {
        self.fetchCurrentPrice { completion() }
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) {(timer) in
            self.homeTimer = timer
            self.fetchCurrentPrice {
               completion()
            }
        }
    }
    
    func fetchCurrentPrice(client: BitcoinClient = BitcoinClient(), completion: @escaping Handler) {
        client.getCurrentPrice { (result) in
            switch result {
            case .success(let currentPrice):
                self.currentPrice = currentPrice
            case .failure(let error):
                self.errors.append(error)
            }
            completion()
        }
    }
    
    func fetchPastPrices(_ numOfDays: Int = Constants.numberOfDays, client: BitcoinClient = BitcoinClient(), completion: @escaping Handler) {
        let operation = BlockOperation {
            let group = DispatchGroup()
            
            for currency in Currency.allCases {
                group.enter()
                BitcoinClient().getHistoricalLists(currency: currency) { (result) in
                    switch result {
                    case .success(let prices):
                        var sortedPrices = prices.sorted { $0.dateValue > $1.dateValue }
                        self.currentPriceByCurrency[currency] = sortedPrices.removeFirst()
                        self.pricesByCurrency[currency] = Array(sortedPrices[0..<numOfDays])

                    case .failure(let error):
                        self.errors.append(error)

                    }
                    
                    group.leave()
                }
            }
            group.wait()
        }
        let completionOperation = BlockOperation {
           completion()
        }
        completionOperation.addDependency(operation)
        operation.start()
        completionOperation.start()
    }
    
    func fetchPricesAtIndex(_ index: Int) -> [Currency: DatePrice] {
        var prices: [Currency: DatePrice] = [:]
        for currency in Currency.allCases {
            guard let datePrices = self.pricesByCurrency[currency] else { return [:] }
            let priceAtIndex = datePrices[index]
            prices[currency] = priceAtIndex
        }
        return prices
    }
}

