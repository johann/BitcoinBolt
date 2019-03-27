//
//  DateHelpers.swift
//  BitcoinKit
//
//  Created by Johann Kerr on 3/24/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation

public extension Date {
    public func monthAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM")
        return dateFormatter.string(from: self)
    }
    
    public func weekday() -> Int {
        return Calendar.current.component(.day, from: self)
    }
}
