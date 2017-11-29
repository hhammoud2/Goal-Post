//
//  UIButtonExt.swift
//  goalpost
//
//  Created by Hammoud Hammoud on 11/28/17.
//  Copyright © 2017 Hammoud Hammoud. All rights reserved.
//

import UIKit

extension UIButton {
    func setSelectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.4270952344, green: 0.7355977297, blue: 0.3868828416, alpha: 1)
    }
    
    func setDeselectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.6982929111, green: 0.8666668534, blue: 0.6875986457, alpha: 1)
    }
}
