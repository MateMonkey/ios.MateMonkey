//
//  MMStockQuantity.swift
//  MateMonkey
//
//  Created by Peter on 14.06.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation

enum MMStockQuantity: Int {
    case crate = 0, piece, kg
    
    func getLocalizedQuantity() -> String {
        switch self {
        case .crate:
            return VisibleStrings.crateStockQuantity
        case .piece:
            return VisibleStrings.pieceStockQuantity
        case .kg:
            return VisibleStrings.kgStockQuantity
        }
    }
}
