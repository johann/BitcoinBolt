//
//  CurrencyViewController.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/24/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import UIKit
import BitcoinKit

class CurrencyViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var eurView: UIView!
    @IBOutlet weak var usdView: UIView!
    @IBOutlet weak var gbpView: UIView!

    var rates: [Currency: DatePrice] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [self.eurView, self.usdView, self.gbpView].forEach { (view) in
            view.layer.cornerRadius = view.bounds.width * 0.5
        }
        self.eurLabel.text = self.rates[Currency.EUR]?.priceWithCurrencyCode
        self.usdLabel.text = self.rates[Currency.USD]?.priceWithCurrencyCode
        self.gbpLabel.text = self.rates[Currency.GBP]?.priceWithCurrencyCode
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd MMMM"
        guard let date = self.rates[Currency.EUR]?.dateValue else { return }
        self.dateLabel.text = dateformatter.string(from: date)
    }

    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
