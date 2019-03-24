//
//  Doube+Currency.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/21/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation

// TODO: FIX
extension Double {
    func currencyFormat(code: Currency) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code.rawValue
        return formatter.string(for: self)
    }
}
