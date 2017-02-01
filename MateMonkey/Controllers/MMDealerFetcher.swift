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
        
        let completeRequestURLString = GlobalValues.testAPI + dealerParameter
        
        print(completeRequestURLString)
        
        // query the API server
        let requestURL: URL = URL(string: completeRequestURLString)!
        let urlRequest: URLRequest = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {data, response , error in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print(data!)
                let dealers = MMJSONParser(data: data!).parse()
                if dealers.count > 0 {
                    // We have one or more dealers in the map area
                    self.results = dealers
                }
            } else {
                print(error.debugDescription)
            }
            
            // call the delegate method
            self.delegate?.queryCompleted(sender: self)
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
