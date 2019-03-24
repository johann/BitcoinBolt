//
//  Datastore.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/21/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation


final class DataStore {
    private init () {}
    static let shared = DataStore()
    var currentPrice: CurrentPrice?
    var currentPriceByCurrency: [Currency: DatePrice] = [:]
    var pricesByCurrency: [Currency: [DatePrice]] = [:]
    var homeTimer: Timer?
    
    
    func fetchCurrentPriceAtInterval(_ timeInterval: TimeInterval = Constants.refreshRate, completion: @escaping () -> ()) {
        self.fetchCurrentPrice { completion() }
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) {(timer) in
            self.homeTimer = timer
            self.fetchCurrentPrice {
               completion()
            }
        }
    }
    
    func fetchCurrentPrice(completion: @escaping () -> ()) {
        ApiClient().getCurrentPrice { (currentPrice) in
            self.currentPrice = currentPrice
            completion()
        }
    }
    
    // TODO rename price to rate
    func fetchPricesAtIndex(_ index: Int) -> [Currency: DatePrice] {
        var prices: [Currency: DatePrice] = [:]
        for currency in Currency.allCases {
            guard let datePrices = self.pricesByCurrency[currency] else { return [:] }
            let priceAtIndex = datePrices[index]
            prices[currency] = priceAtIndex
        }
        return prices
    }
    
    func fetchPastPrices(_ numOfDays: Int = Constants.numberOfDays, completion: @escaping () -> ()) {
        let operation = BlockOperation {
            let group = DispatchGroup()
            
            for currency in Currency.allCases {
                group.enter()
                ApiClient().getHistoricalLists(currency: currency, completion: { (prices) in
                    if let prices = prices {
                        var sortedPrices = prices.sorted { $0.dateValue > $1.dateValue }
                        self.currentPriceByCurrency[currency] = sortedPrices.removeFirst()
                        self.pricesByCurrency[currency] = Array(sortedPrices[0..<numOfDays])
                    }
                    group.leave()
                })
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
}
