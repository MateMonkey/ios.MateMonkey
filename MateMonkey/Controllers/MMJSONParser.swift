//
//  MMJSONParser.swift
//  MateMonkey
//
//  Created by Peter on 01.02.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation

class MMJSONParser {
    
    private var data: Data
    private var dealerArray = [MMDealer]()
    
    init(data: Data) {
        self.data = data
    }
    
    func parse() -> [MMDealer] {
        do {
            let json = try? JSONSerialization.jsonObject(with: self.data, options: [])
            if let fullQueryDictionary = json as? [String: Any] {
                
                // Check for errors: valid API URL with invalid/wrong parameters
                if let errorTitle = fullQueryDictionary["title"] as? String {
                    if let errorMessages = fullQueryDictionary["messages"] as? [String] {
                        // TODO: Figure out what to do with potential error messages.
                        print(errorTitle)
                        for message in errorMessages {
                            print(message)
                        }
                    }
                }
                // Count the resulting dealers
                if let dealerCount = fullQueryDictionary["count"] as? Int {
                    if dealerCount > 0 {
                        // We have one or more dealers. Get the array from the main dict
                        if let dealerArray = fullQueryDictionary["dealers"] as? [Any] {
                            // Iterate through them
                            for dealer in dealerArray {
                                var formattedAddress: MMAddress?
                                var formattedDealer: MMDealer?
                                // Check to see if it really is a dict
                                if let dealerDict = dealer as? [String:Any] {
                                    // Get the adress first
                                    if let dealerAddress = dealerDict["address"] as? [String: Any] {
                                        let street = dealerAddress["street"] as! String
                                        let number = getContentOrEmptyString(item: dealerAddress["number"])
                                        let country = dealerAddress["country"] as! String
                                        let city = dealerAddress["city"] as! String
                                        let postal = dealerAddress["postal"] as! String
                                        let lat = dealerAddress["lat"] as! Float
                                        let lon = dealerAddress["lon"] as! Float
                                        
                                        let web = getContentOrEmptyString(item: dealerAddress["web"])
                                        let email = getContentOrEmptyString(item: dealerAddress["email"])
                                        let phone = getContentOrEmptyString(item: dealerAddress["phone"])
                                        
                                        let address = MMAddress(street: street, number: number, country: country, city: city, postal: postal, lat: lat, lon: lon, web: web, email: email, phone: phone)
                                        
                                        formattedAddress = address
                                    }
                                    if formattedAddress != nil {
                                        let name = dealerDict["name"] as! String
                                        let id = dealerDict["id"] as! Int
                                        let type = dealerDict["type"] as! String
                                        let note = getContentOrEmptyString(item: dealerDict["note"])
                                        let currency = dealerDict["currency"] as! String
                                        
                                        let address = formattedAddress!
                                        
                                        let finalDealer = MMDealer(name: name, id: id, type: type, note: note, currency: currency, address: address)
                                        
                                        formattedDealer = finalDealer
                                        
                                        // Add it to the results array
                                        self.dealerArray.append(formattedDealer!)
                                    }
                                }
                                
                            }
                        }
                    } else {
                        print("There were no dealers in this map area.")
                    }
                }
            }
        }
        return dealerArray
    }
    
    private func getContentOrEmptyString(item: Any?) -> String {
        if let nonNilString = item as? String {
            return nonNilString
        } else {
            return ""
        }
    }
}
