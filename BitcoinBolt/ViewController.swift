//
//  ViewController.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/20/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var prices = [DatePrice]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todaysPriceLabel: UILabel!
    let store = DataStore.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupHeader()
        setupTable()
    }
    
    func setupHeader() {
        store.fetchCurrentPrice {
            DispatchQueue.main.async {
                if let price = self.store.currentPrice {
                    self.todaysPriceLabel.text = price.eurPrice.rate
                }
            }
        }
    }
    
    func setupTable() {
        store.fetchAllPrices {
            guard let prices = self.store.prices[Constants.defaultCurrency] else { return }
            self.prices = prices
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Can do some nice loading by providing constant number
        return self.prices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
        
        let datePrice = self.prices[indexPath.row]
        
        cell.textLabel?.text = "\(datePrice.price)"
        cell.detailTextLabel?.text = "\(datePrice.date)"
        return cell
    }
}
