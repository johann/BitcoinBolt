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
    var prices: [Currency: [DatePrice]] = [:]
    
    
    
    func fetchByDate() {
        for (key, value) in prices {
            
        }
    }
    
    func fetchCurrentPrice(completion: @escaping () -> ()) {
        ApiClient().getCurrentPrice { (currentPrice) in
            self.currentPrice = currentPrice
            completion()
        }
    }
    
    func fetchAllPrices(completion: @escaping () -> ()) {
        let operation = BlockOperation {
            let group = DispatchGroup()
            
            for currency in Currency.allCases {
                group.enter()
                print("currency")
                ApiClient().getHistoricalLists(currency: currency, completion: { (prices) in
                    if let prices = prices {
                        self.prices[currency] = prices.sorted { $0.dateValue > $1.dateValue }.removeFirst(Constants.numberOfDays)
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
