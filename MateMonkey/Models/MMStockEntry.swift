//
//  MMStockEntry.swift
//  MateMonkey
//
//  Created by Peter on 12.06.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation

class MMStockEntry {
    let status: MMStockStatus
    let product: MMProduct
    let price: String
    
    init(status: MMStockStatus = .unknown, product: MMProduct, price: String = "?") {
        self.status = status
        self.product = product
        self.price = price
    }
    
    init(json: [String:Any]) throws {
        // Extract status
        guard let statusString = json["status"] as? String else {
            throw SerializationError.missing("status")
        }
        // Extract extract price
        guard let price = json["price"] as? String else {
            throw SerializationError.missing("price")
        }
        
        switch statusString {
        case "discontinued":
            self.status = .discontinued
            break
        case "sold-out":
            self.status = .soldout
            break
        case "low":
            self.status = .low
            break
        case "full":
            self.status = .full
            break
        case "unknown":
            self.status = .unknown
            break
        default:
            self.status = .unknown
        }
        
        if price != "?" {
            let insertIndex = price.index(price.endIndex, offsetBy: -2)
            var mutablePrice = price
            mutablePrice.insert(".", at: insertIndex)
            self.price = mutablePrice
        } else {
            self.price = price
        }
        
        // Extract product
        do {
            let product = try MMProduct(json: json["product"] as! [String : Any])
            self.product = product
        } catch {
            throw SerializationError.invalid("product", json["product"]!)
        }

    }
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
}
