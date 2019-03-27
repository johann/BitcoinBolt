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

public enum NetworkError: Error {
    case noResults
    case jsonParsing
    case badUrl
}


extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .noResults:
                return NSLocalizedString("No results", comment: "")
            case .jsonParsing:
                return NSLocalizedString("Error parsing response", comment: "")
            case .badUrl:
                return NSLocalizedString("Error with API host", comment: "")
        }
    }
}

public class BitcoinClient {
    var service: WebService
    public init(service: WebService) { self.service = service }
    public init() { self.service = WebService() }
    public typealias CurrentPriceHandler = (Result<CurrentPrice, NetworkError>) -> Void
    public typealias DatePriceHandler = (Result<[DatePrice], NetworkError>) -> Void
    
    public func getCurrentPrice(currency: Currency = .EUR, result:@escaping CurrentPriceHandler) {
        guard let url = URL(.currentPrice(currency)) else { result(.failure(.badUrl)); return }
        
        self.service.request(url: url) { (data, error) in
            guard let currentPrice = data.flatMap(CurrentPrice.parse) else {
                result(.failure(.noResults))
                return
            }

            result(.success(currentPrice))
        }
    }
    
    public func getHistoricalLists(currency: Currency = .EUR, result: @escaping DatePriceHandler) {
        guard let url = URL(.historicalPrice(currency)) else { result(.failure(.badUrl)); return }
        
        self.service.request(url: url) { (data, error) in
            if let data = data {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                    let bpi = jsonData["bpi"] as? [String: Any] ?? [:]
                    var prices = [DatePrice]()
                    for (date, price) in bpi {
                        if let price = price as? Double {
                            prices.append(DatePrice(date: date, currency: currency.rawValue, price: price))
                        }
                    }
                    
                    if (prices.count > 0) {
                        result(.success(prices))
                    } else {
                        result(.failure(.noResults))
                    }
                } catch {
                    result(.failure(.jsonParsing))
                }
            }
        }
    }
}




