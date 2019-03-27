//
//  TodayViewController.swift
//  Bolt Widget
//
//  Created by Johann Kerr on 3/24/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import UIKit
import NotificationCenter
import BitcoinKit

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var bitcoinImageView: UIImageView!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCurrentPriceAtInterval { (currentPrice) in
            guard let currentPrice = currentPrice else { return }
            DispatchQueue.main.async {
                self.bitcoinImageView.image = UIImage(named: "BC_Logo_.png")
                self.priceLabel.text = currentPrice.eurPrice.priceWithCurrencyCode
            }
            
            self.fetchYesterdaysPrice{ (datePrice) in
                let difference = currentPrice.eurPrice.rate_float - datePrice.price
                DispatchQueue.main.async {
                    if difference >= 0 {
                        self.differenceLabel.text = "+ \(difference)"
                        self.differenceLabel.textColor = UIColor.green
                    } else {
                        self.differenceLabel.text = "- \(difference)"
                        self.differenceLabel.textColor = UIColor.red
                    }
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let timer = self.timer {
            timer.invalidate()
        }
    }
    
    
    private func fetchCurrentPriceAtInterval(_ timeInterval: TimeInterval = 10.0, completion: @escaping (CurrentPrice?) -> ()) {
        BitcoinClient().getCurrentPrice { currentPrice in
            completion(currentPrice)
        }
        
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) {(timer) in
            BitcoinClient().getCurrentPrice { currentPrice in
                self.timer = timer
                completion(currentPrice)
            }
        }
    }
    
    
    func fetchYesterdaysPrice(completion: @escaping (DatePrice) -> ()) {
        BitcoinClient().getHistoricalLists { (prices) in
            if let prices = prices {
                var sortedPrices = prices.sorted { $0.dateValue > $1.dateValue }
                let yesterday = sortedPrices[1]
                completion(yesterday)
            }
            
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
