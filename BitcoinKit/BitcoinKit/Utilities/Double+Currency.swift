//
//  Double+Currency.swift
//  BitcoinKit
//
//  Created by Johann Kerr on 3/24/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation

public extension Double {
    public func currencyFormat(code: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        return formatter.string(for: self)
    }
}
