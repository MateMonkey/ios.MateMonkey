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
    let quantity: MMStockQuantity
    let created: Date
    
    init(status: MMStockStatus = .unknown, product: MMProduct, price: String = "?", quantity: MMStockQuantity = .crate, created: Date = Date()) {
        self.status = status
        self.product = product
        self.price = price
        self.quantity = quantity
        self.created = created
    }
    
    init(json: [String:Any]) throws {
        // Extract status
        guard let statusString = json["status"] as? String else {
            throw SerializationError.missing("status")
        }
        
        // Extract price
        priceExtract: if let price = json["price"] as? String {
            if price == "?" {
                self.price = price
            } else {
                throw SerializationError.invalid("price", price)
            }
        } else if let price = json["price"] as? Int {
            guard price != 0 else {
                self.price = "?"
                break priceExtract
            }
            var priceString = String(price)
            let insertIndex = priceString.index(priceString.endIndex, offsetBy: -2)
            priceString.insert(".", at: insertIndex)
            self.price = priceString
        } else {
            throw SerializationError.invalid("price", json["price"]!)
        }
        
        // get the status enum from the status(string)
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
        
        if let quantityString = json["quantity"] as? String {
            switch quantityString {
            case "crate":
                self.quantity = .crate
                break
            case "piece":
                self.quantity = .piece
                break
            case "kg":
                self.quantity = .kg
                break
            default:
                self.quantity = .crate
            }
        } else {
            self.quantity = .crate
        }
        
        // Extract product
        do {
            let product = try MMProduct(json: json["product"] as! [String : Any])
            self.product = product
        } catch {
            throw SerializationError.invalid("product", json["product"]!)
        }
        
        // Get the time of creation for the entry
        do {
            if let createString = json["created_at"] as? String {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                
                if let createDate = dateFormatter.date(from: createString) {
                    self.created = createDate
                } else {
                    throw SerializationError.invalid("created_at", json["created_at"]!)
                }
            } else {
                throw SerializationError.missing("created_at")
            }

        }
    }
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
}
