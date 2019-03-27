//
//  Endpoint.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/21/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation

public enum Endpoint {
  case currentPrice(Currency)
  case historicalPrice(Currency)
  var apiBase: String {
    get {
      return "https://api.coindesk.com/v1/bpi/"
    }
  }
  
  var path: String {
    switch self {
    case .currentPrice(let currency):
      return "currentprice/\(currency).json"
    case .historicalPrice(let currency):
      return "historical/close.json?currency=\(currency)"
    }
  }
  
  func url() -> String {
    return "\(apiBase)\(self.path)"
  }
}

extension URL {
  init?(_ endpoint: Endpoint) {
    let url = endpoint.url()
    self.init(string: url)
  }
}

