//
//  MMDealerFetcher.swift
//  MateMonkey
//
//  Created by Peter on 30.01.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation
import MapKit

protocol MMDealerFetcherDelegate {
    func queryCompleted(sender: MMDealerFetcher)
}

class MMDealerFetcher {
    
    var delegate: MMDealerFetcherDelegate?
    
    var queryData: Data?
    
    var results = [MMDealer]()
    
    func queryForMapRect(_ mapRect: MKMapRect) {
        
        // Create a query for the given map rect
        let bottomLeftLatitude = String(getSWCoordinateFromMapRect(mapRect).latitude)
        let bottomLeftLongitude = String(getSWCoordinateFromMapRect(mapRect).longitude)
        
        let topRightLatitude = String(getNECoordinateFromMapRect(mapRect).latitude)
        let topRightLongitude = String(getNECoordinateFromMapRect(mapRect).longitude)
        
        let dealerParameter = "dealers?bbox=" + bottomLeftLatitude + "," + bottomLeftLongitude + "," + topRightLatitude + "," + topRightLongitude
        
        let completeRequestURLString = GlobalValues.baseURL + dealerParameter
        
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
                if let dealers = try? MMJSONParser(data: data!).parse() {
                    if dealers.count > 0 {
                        // We have one or more dealers in the map area
                        self.results = dealers
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
    
    func queryForDealerSlug(_ slug: String) {
        let requestURLString = GlobalValues.baseURL + "dealers/" + slug
        
        // query the API server
        let requestURL: URL = URL(string: requestURLString)!
        let urlRequest: URLRequest = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            var statusCode = Int()
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
            }
            
            if (statusCode == 200) {
                // Dealer found
                print("Data returned by server: \(data!)")
                do {
                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let dealer = try? MMDealer(json: json as! [String : Any]) {
                        self.results.append(dealer)
                        self.delegate?.queryCompleted(sender: self)
                    }
                }
            } else if (statusCode == 404) {
                // No results
                print("No results.")
            } else {
                // Another error altogether
                print("Request error. Status code: \(statusCode). Error: \(String(describing: error?.localizedDescription))")
            }
        }
        task.resume()
    }
    
    // MARK: - Map methods
    func getNECoordinateFromMapRect(_ mRect: MKMapRect) -> CLLocationCoordinate2D {
        return getCoordinateFromMapRectanglePoint(x: MKMapRectGetMaxX(mRect), y: mRect.origin.y)
    }
    
    func getSWCoordinateFromMapRect(_ mRect: MKMapRect) -> CLLocationCoordinate2D {
        return getCoordinateFromMapRectanglePoint(x: mRect.origin.x, y: MKMapRectGetMaxY(mRect))
    }
    
    func getCoordinateFromMapRectanglePoint(x: Double, y: Double) -> CLLocationCoordinate2D {
        let swMapPoint = MKMapPointMake(x, y)
        return MKCoordinateForMapPoint(swMapPoint)
    }
    
}
