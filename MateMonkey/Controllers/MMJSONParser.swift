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
    private var dealerResultArray = [MMDealer]()
    private var stockResultArray = [MMStockEntry]()
    private var productResultDict = [Int: String]()
    
    init(data: Data) {
        self.data = data
    }
    
    func parseDealers() throws -> [MMDealer] {
        do {
            let json = try? JSONSerialization.jsonObject(with: self.data, options: [])
            if let fullQueryDictionary = json as? [String: Any] {
                
                // Check for errors: valid API URL with invalid/wrong parameters
                if let errorTitle = fullQueryDictionary["title"] as? String {
                    if let errorMessages = fullQueryDictionary["messages"] as? [String] {
                        throw JSONParserError(title: errorTitle, messages: errorMessages, kind: .serverReturnedError)
                    }
                }
                // Count the resulting dealers
                if let dealerCount = fullQueryDictionary["count"] as? Int {
                    if dealerCount > 0 {
                        // We have one or more dealers. Get the array from the main dict
                        if let dealerArray = fullQueryDictionary["dealers"] as? Array<Dictionary<String, Any>> {
                            // Iterate through them
                            for dealer in dealerArray {
                                do {
                                    let newDealer = try MMDealer(json: dealer)
                                    dealerResultArray.append(newDealer)
                                } catch {
                                    print(error)
                                    throw JSONParserError(title: "Could not extract dealer", messages: [], kind: .parsingItemError)
                                }
                            }
                        }
                    } else {
                        print("There were no dealers in this map area.")
                    }
                }
            }
        }
        return dealerResultArray
    }
    
    func parseStock() throws -> [MMStockEntry] {
        do {
            let json = try? JSONSerialization.jsonObject(with: self.data, options: [])
            if let fullQueryDictionary = json as? [String: Any] {
                
                // Check for errors: valid API URL with invalid/wrong parameters
                if let errorTitle = fullQueryDictionary["title"] as? String {
                    if let errorMessages = fullQueryDictionary["messages"] as? [String] {
                        throw JSONParserError(title: errorTitle, messages: errorMessages, kind: .serverReturnedError)
                    }
                }
                // Count the resulting dealers
                if let entryCount = fullQueryDictionary["count"] as? Int {
                    if entryCount > 0 {
                        // We have one or more dealers. Get the array from the main dict
                        if let stockEntryArray = fullQueryDictionary["entries"] as? Array<Dictionary<String, Any>> {
                            // Iterate through them
                            for entry in stockEntryArray {
                                do {
                                    let newEntry = try MMStockEntry(json: entry)
                                    stockResultArray.append(newEntry)
                                } catch {
                                    print(error)
                                    throw JSONParserError(title: "Could not extract entry", messages: [], kind: .parsingItemError)
                                }
                            }
                        }
                    } else {
                        print("This dealer has no stock entries.")
                    }
                }
            }
        }
        return stockResultArray
    }
    
    func parseProductList() throws -> [Int:String] {
        do {
            let json = try? JSONSerialization.jsonObject(with: self.data, options: [])
            if let fullDictionary = json as? [String: Any] {
                
                if let entryCount = fullDictionary["count"] as? Int {
                    if entryCount > 0 {
                        if let productArray = fullDictionary["products"] as? Array<Dictionary<String,Any>> {
                            for entry in productArray {
                                do {
                                    let newProduct = try MMProduct(json: entry)
                                    productResultDict[newProduct.id] = newProduct.name
                                } catch {
                                    print(error)
                                    throw JSONParserError(title: "Could not extract product", messages: [], kind: .parsingItemError)
                                }
                            }
                        }
                    } else {
                        print("There are no products.")
                    }
                }
            }
        }
        return productResultDict
    }

    
    struct JSONParserError: Error {
        enum ErrorKind {
            case serverReturnedError
            case parsingItemError
        }
        
        let title: String
        let messages: [String]
        let kind: ErrorKind
    }

}
