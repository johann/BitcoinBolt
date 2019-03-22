//
//  ApiClient.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/20/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation


final class WebService {
    func request(url: URL, completion: @escaping (Data?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            completion(data, error)
            }.resume()
    }
}

class ApiClient {
    var service: WebService
    init(service: WebService) { self.service = service }
    init() { self.service = WebService() }
    
    func getCurrentPrice(currency: Currency = .EUR, completion:@escaping (CurrentPrice?) -> ()) {
        guard let url = URL(.currentPrice(currency)) else { return }
        self.service.request(url: url) { (data, error) in
            let currentPrice = data.flatMap(CurrentPrice.parse)
            completion(currentPrice)
        }
    }
    
    func getHistoricalLists(currency: Currency = .EUR, completion: @escaping ([DatePrice]?) -> ()) {
        guard let url = URL(.historicalPrice(currency)) else { return }
    
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let data = data {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                    
                    let bpi = jsonData["bpi"] as? [String: Any] ?? [:]
                    var prices = [DatePrice]()
                    for (date, price) in bpi {
                        if let price = price as? Double {
                            prices.append(DatePrice(date: date, price: price, currency: currency))
                        } else {
                            // TODO: - Error
                            completion(nil)
                        }
                    }
                    completion(prices)
                } catch {
                    completion(nil)
                }
            }
        }.resume()
    }
}




