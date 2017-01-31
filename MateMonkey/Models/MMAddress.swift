//
//  MMAddress.swift
//  MateMonkey
//
//  Created by Peter on 31.01.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation

class MMAddress {
    let street: String
    let number: String
    let country: String
    let city: String
    let postal: String
    let lat: Double
    let lon: Double
    let web: String
    let email: String
    let phone: String
    
    init(street: String, number: String, country: String, city: String, postal: String, lat: Float, lon: Float, web: String, email: String, phone: String) {
        
        self.street = street
        self.number = number
        self.country = country
        self.city = city
        self.postal = postal
        self.lat = Double(lat)
        self.lon = Double(lon)
        self.web = web
        self.email = email
        self.phone = phone
    }
}
