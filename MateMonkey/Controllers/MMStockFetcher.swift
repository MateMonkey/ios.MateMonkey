//
//  MMStockFetcher.swift
//  MateMonkey
//
//  Created by Peter on 13.06.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation

protocol MMStockFetcherDelegate {
    func queryCompleted(sender: MMStockFetcher)
}

class MMStockFetcher {
    
    var delegate: MMStockFetcherDelegate?
    
    var queryData: Data?
    
    var results = [MMStockEntry]()
    
    func queryForDealerId(_ id: Int) {
                
        let parameter = "dealers/" + String(id) + "/stock?current=true"
        
        let completeRequestURLString = GlobalValues.baseURL + parameter
        
        print(completeRequestURLString)
        
        // query the API server
        let requestURL: URL = URL(string: completeRequestURLString)!
        let urlRequest: URLRequest = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {data, response , error in
            
            var statusCode = Int()
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
            }
            
            if (statusCode == 200) {
                print(data!)
                if let stock = try? MMJSONParser(data: data!).parseStock() {
                    if stock.count > 0 {
                        // We have one or more dealers in the map area
                        self.results = stock
                    } else {
                        self.results = []
                    }
                } else {
                    // TODO: The parser neatly throws an error, we should be able to look into it more precisely
                    print("ParserError")
                }
            } else {
                print(error.debugDescription)
            }
            
            // call the delegate method
            self.delegate?.queryCompleted(sender: self)
        }
        task.resume()
    }
    
}
