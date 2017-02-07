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
    let name: String
    let id: Int
    let type: MMDealerType
    let note: String
    let currency: String
    let address: MMAddress
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?
    
    init(name: String, id: Int, type: String, note: String, currency: String, address: MMAddress) {
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
}
