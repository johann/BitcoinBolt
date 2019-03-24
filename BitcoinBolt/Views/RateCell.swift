//
//  RateCell.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/24/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import UIKit

class RateCell: UICollectionViewCell {
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    func configureCell(_ price: DatePrice) {
        self.rateLabel.text = price.priceWithCurrencyCode
        self.dayLabel.text = "\(price.dateValue.weekday())"
        self.monthLabel.text = "\(price.dateValue.monthAsString())"
    }
    
}
