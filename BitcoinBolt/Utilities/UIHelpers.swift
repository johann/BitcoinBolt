//
//  UIHelpers.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/24/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func hideNavigationBarMargin() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
}
