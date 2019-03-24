//
//  PriceViewController.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/21/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import UIKit

class PriceViewController: UIViewController {

    @IBOutlet weak var priceTableView: UITableView!
    struct PriceObject {
        var price: String
        var currency: String
    }
    var priceObjects = [PriceObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.priceTableView.delegate = self
        self.priceTableView.dataSource = self
    }
    
    func configureView(prices: [Currency : DatePrice]) {
        for (key, value) in prices {
            self.priceObjects.append(PriceObject(price: value.priceWithCurrencyCode, currency: key.rawValue))
        }
    }
}


extension PriceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.priceObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
        let priceObject = self.priceObjects[indexPath.row]
        cell.textLabel?.text = "\(priceObject.price)"
        cell.detailTextLabel?.text = "\(priceObject.currency)"

        return cell
    }
}
