//
//  ViewController.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/20/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todaysPriceLabel: UILabel!
    @IBOutlet weak var currentPriceButton: UIButton!
    
    var prices = [DatePrice]()
    var selectedPrice: [Currency: DatePrice] = [:]
    var selectedIndex: Int = 0
    let store = DataStore.shared
    
    
    // MARK: LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        setupTable()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let timer = store.homeTimer else { return }
        timer.invalidate()
    }
    
    
    // MARK: View Helpers
    
    func setupHeader() {
        store.fetchCurrentPriceAtInterval {
            DispatchQueue.main.async {
                if let price = self.store.currentPrice {
                    self.todaysPriceLabel.text = price.eurPrice.priceWithCurrencyCode
                }
            }
        }
    }
    
    func setupTable() {
        store.fetchPastPrices {
            guard let prices = self.store.pricesByCurrency[Constants.defaultCurrency] else { return }
            self.prices = prices
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func currentPriceButtonPressed(_ sender: Any) {
        self.selectedPrice = self.store.currentPriceByCurrency
        performSegue(withIdentifier: "showPrice", sender: sender)
    }
    
    
}

// MARK: Segue Management
extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPrice" {

        
        }
    }
}


// MARK: TableView Delegate & Datasource
extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
        
        let datePrice = self.prices[indexPath.row]
        
        cell.textLabel?.text = "\(datePrice.priceWithCurrencyCode)"
        cell.detailTextLabel?.text = "\(datePrice.date)"
        return cell
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
        
    }
}
