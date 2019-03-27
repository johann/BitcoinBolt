//
//  BitcoinBoltTests.swift
//  BitcoinBoltTests
//
//  Created by Johann Kerr on 3/20/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import XCTest
@testable import BitcoinBolt
@testable import BitcoinKit

class BitcoinBoltTests: XCTestCase {
    func testListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateInitialViewController() as? UINavigationController
        let listVC = nav?.viewControllers.first as! ListViewController

        listVC.loadViewIfNeeded()
        var prices = [DatePrice]()
        for _ in 1...14 {
            let price = Int(arc4random_uniform(100))
            prices.append(DatePrice(date: "2019-02-24", currency: "EUR", price: Double(price)))
        }
    
        listVC.rates = prices
        
        listVC.collectionView.reloadData()
        XCTAssertEqual(listVC.collectionView.numberOfItems(inSection: 0), 14)
    }
}
