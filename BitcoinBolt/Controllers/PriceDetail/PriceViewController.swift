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
    var prices: [Currency: [DatePrice]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.priceTableView.delegate = self
        self.priceTableView.dataSource = self
        
    }
}


extension PriceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)

        return cell
    }
}
