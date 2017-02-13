//
//  MMJSONSender.swift
//  MateMonkey
//
//  Created by Peter on 08.02.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation

protocol JSONSenderDelegate {
    func requestCompleted(success: Bool, updatedDealer: MMDealer?)
}

class MMJSONSender {
    
    var delegate: JSONSenderDelegate?
    
    func updateDealer(_ dealer: MMDealer, updatedData data: [String: Any]) {
        // compare both dealers and create a JSON of the changes
        
        var json = [String: Any]()
        
        for item in data {
            json[item.key] = item.value
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let targetURLString = GlobalValues.testAPI + "dealers/" + String(dealer.id)
        let url = URL(string: targetURLString)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data returned")
                self.delegate?.requestCompleted(success: false, updatedDealer: nil)
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let returnedJSON = responseJSON as? [String: Any] {
                print(returnedJSON)
                if let dealer = try? MMDealer(json: returnedJSON) {
                    self.delegate?.requestCompleted(success: true, updatedDealer: dealer)
                } else {
                    self.delegate?.requestCompleted(success: true, updatedDealer: nil)
                }
            }
        }
        task.resume()

    }
    
    func addDealer(name: String, type: MMDealerType, address: MMAddress, optionalNote note: String) {
        let jsonAddress = getJsonDictionary(forAddress: address)
        
        guard name != "" else {
            delegate?.requestCompleted(success: false, updatedDealer: nil)
            return
        }
        
        var json: [String: Any] = ["name": name,
                                   "type": String(describing: type),
                                   "address": jsonAddress]
        if note != "" {
            json["note"] = note
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let targetURLString = GlobalValues.testAPI + "dealers"
        let url = URL(string: targetURLString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                self.delegate?.requestCompleted(success: false, updatedDealer: nil)
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let returnedJSON = responseJSON as? [String: Any] {
                if let dealer = try? MMDealer(json: returnedJSON) {
                    self.delegate?.requestCompleted(success: true, updatedDealer: dealer)
                } else {
                    self.delegate?.requestCompleted(success: true, updatedDealer: nil)
                }
            }
        }
        task.resume()
    }
    
    
    // MARK: - Private functions
    
    private func getJsonDictionary(forAddress address: MMAddress) -> [String: Any] {
        var addressDict: [String: Any]
        
        if address.street == "" {
            addressDict = ["lat": address.lat,
                           "lon": address.lon]
        } else {
            addressDict = ["street": address.street, "country": address.country, "city": address.city, "postal": address.postal]
            if address.number != "" {
                addressDict["number"] = address.number
            }
        }
        
        if address.web != "" {
            addressDict["web"] = address.web
        }
        if address.email != "" {
            addressDict["email"] = address.email
        }
        if address.phone != "" {
            addressDict["phone"] = address.phone
        }
        
        return addressDict
    }
}
