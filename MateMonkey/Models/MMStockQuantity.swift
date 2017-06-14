//
//  MMStockQuantity.swift
//  MateMonkey
//
//  Created by Peter on 14.06.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation

enum MMStockQuantity: String {
    case crate = "crate"
    case piece = "piece"
    case kg = "kg"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static func getQuantity(_ quantity: MMStockQuantity) -> String {
        return quantity.localizedString()
    }
}
