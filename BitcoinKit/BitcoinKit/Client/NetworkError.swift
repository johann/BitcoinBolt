//
//  NetworkError.swift
//  BitcoinKit
//
//  Created by Johann Kerr on 4/2/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation

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
