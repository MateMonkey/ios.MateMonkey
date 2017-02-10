//
//  MMDealer.swift
//  MateMonkey
//
//  Created by Peter on 31.01.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MMDealer: NSObject, MKAnnotation {
    var name: String
    let id: Int
    var type: MMDealerType
    var note: String
    let currency: String
    var address: MMAddress
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?
    
    init(name: String, id: Int, type: String, note: String = "", currency: String, address: MMAddress) {
        
        self.name = name
        self.id = id
        self.note = note
        self.currency = currency
        self.address = address
        
        switch type {
        case "bar":
            self.type = .bar
        case "club":
            self.type = .club
        case "retail":
            self.type = .retail
        case "restaurant":
            self.type = .restaurant
        case "other":
            self.type = .other
        case "hackerspace":
            self.type = .hackerspace
        case "community":
            self.type = .community
        default:
            self.type = .other
        }
        
        let coord = CLLocationCoordinate2D(latitude: address.lat, longitude: address.lon)
        self.coordinate = coord
        
        self.title = String(self.id)
        self.subtitle = String(describing: self.type)
        
        super.init()
    }
    
    
    // MARK: - JSON initializer
    init(json: [String: Any]) throws {
        // Extract name
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        // Extract id
        guard let id = json["id"] as? Int else {
            throw SerializationError.missing("id")
        }
        // Extract type
        guard let type = json["type"] as? String else {
            throw SerializationError.missing("type")
        }
        // Extract currency
        guard let currency = json["currency"] as? String else {
            throw SerializationError.missing("currency")
        }
        
        self.name = name
        self.id = id
        self.currency = currency
        
        switch type {
        case "bar":
            self.type = .bar
        case "club":
            self.type = .club
        case "retail":
            self.type = .retail
        case "restaurant":
            self.type = .restaurant
        case "other":
            self.type = .other
        case "hackerspace":
            self.type = .hackerspace
        case "community":
            self.type = .community
        default:
            self.type = .other
        }
        
        // Extract address
        do {
            let address = try MMAddress(json: json["address"] as! [String : Any])
            self.address = address
            
            let coord = CLLocationCoordinate2D(latitude: address.lat, longitude: address.lon)
            self.coordinate = coord
        } catch {
            throw SerializationError.invalid("address", json["address"]!)
        }
        
        // Extract note (optional)
        if let note = json["note"] as? String {
            self.note = note
        } else {
            self.note = ""
        }
        
        
    }
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
}
