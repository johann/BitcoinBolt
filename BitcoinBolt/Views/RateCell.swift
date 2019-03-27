//
//  RateCell.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/24/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import UIKit
import BitcoinKit

class RateCell: UICollectionViewCell {
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    func configureCell(_ rate: DatePrice) {
        self.rateLabel.text = rate.priceWithCurrencyCode
        self.dayLabel.text = "\(rate.dateValue.weekday())"
        self.monthLabel.text = "\(rate.dateValue.monthAsString())"
    }
    
}
