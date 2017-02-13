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
    private var resultArray = [MMDealer]()
    
    init(data: Data) {
        self.data = data
    }
    
    func parse() throws -> [MMDealer] {
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
                                    resultArray.append(newDealer)
                                } catch {
                                    print(error)
                                    throw JSONParserError(title: "Could not extract dealer", messages: [], kind: .parsingDealerError)
                                }
                            }
                        }
                    } else {
                        print("There were no dealers in this map area.")
                    }
                }
            }
        }
        return resultArray
    }
        
    struct JSONParserError: Error {
        enum ErrorKind {
            case serverReturnedError
            case parsingDealerError
        }
        
        let title: String
        let messages: [String]
        let kind: ErrorKind
    }

}
