//
//  ApiClient.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/20/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation



public class WebService {
    func request(url: URL, completion: @escaping (Data?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            completion(data, error)
            }.resume()
    }
}

public class BitcoinClient {
    var service: WebService
    public init(service: WebService) { self.service = service }
    public init() { self.service = WebService() }
    
    public func getCurrentPrice(currency: Currency = .EUR, completion:@escaping (CurrentPrice?) -> ()) {
        guard let url = URL(.currentPrice(currency)) else { return }
        self.service.request(url: url) { (data, error) in
            let currentPrice = data.flatMap(CurrentPrice.parse)
            completion(currentPrice)
        }
    }
    
    public func getHistoricalLists(currency: Currency = .EUR, completion: @escaping ([DatePrice]?) -> ()) {
        guard let url = URL(.historicalPrice(currency)) else { return }
    
        self.service.request(url: url) { (data, error) in
            if let data = data {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                    
                    let bpi = jsonData["bpi"] as? [String: Any] ?? [:]
                    var prices = [DatePrice]()
                    for (date, price) in bpi {
                        if let price = price as? Double {
                            prices.append(DatePrice(date: date, currency: currency.rawValue, price: price))
                        } else {
                            completion(nil)
                        }
                    }
                    completion(prices)
                } catch {
                    completion(nil)
                }
            }
        }
    }
}




