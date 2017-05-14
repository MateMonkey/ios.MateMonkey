//
//  MMAddress.swift
//  MateMonkey
//
//  Created by Peter on 31.01.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation

class MMAddress {
    var street: String
    var number: String
    var country: String
    var city: String
    var postal: String
    var lat: Double
    var lon: Double
    var web: String
    var email: String
    var phone: String
    
    init(street: String, country: String, city: String, postal: String, lat: Float, lon: Float, number: String = "", web: String = "", email: String = "", phone: String = "") {
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
    
    init(json: [String: Any]) throws {
        // Extract street
        guard let street = json["street"] as? String else {
            throw SerializationError.missing("street")
        }
        // Extract country
        guard let country = json["country"] as? String else {
            throw SerializationError.missing("country")
        }
        // Extract city
        guard let city = json["city"] as? String else {
            throw SerializationError.missing("city")
        }
        // Extract postal
        guard let postal = json["postal"] as? String else {
            throw SerializationError.missing("postal")
        }
        // Extract lat
        guard let lat = json["lat"] as? Float else {
            throw SerializationError.missing("lat")
        }
        // Extract lon
        guard let lon = json["lon"] as? Float else {
            throw SerializationError.missing("lon")
        }
        
        self.street = street
        self.country = country
        self.city = city
        self.postal = postal
        self.lat = Double(lat)
        self.lon = Double(lon)
        
        // Get the optional values
        if let number = json["number"] as? String {
            self.number = number
        } else {
            self.number = ""
        }
        
        if let web = json["web"] as? String {
            self.web = web
        } else {
            self.web = ""
        }
        
        if let email = json["email"] as? String {
            self.email = email
        } else {
            self.email = ""
        }
        
        if let phone = json["phone"] as? String {
            self.phone = phone
        } else {
            self.phone = ""
        }
    }
    
    enum SerializationError: Error {
        case missing(String)
    }
}
