//
//  MMStockStatus.swift
//  MateMonkey
//
//  Created by Peter on 12.06.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation

enum MMStockStatus: Int {
    case discontinued = 0, soldout, low, full, unknown
    
    func getLocalizedStatus() -> String {
        switch self {
        case .discontinued:
            return VisibleStrings.discontinuedStockStatus
        case .soldout:
            return VisibleStrings.soldoutStockStatus
        case .low:
            return VisibleStrings.lowStockStatus
        case .full:
            return VisibleStrings.fullStockStatus
        case .unknown:
            return VisibleStrings.unknownStockStatus
        }
    }
}
