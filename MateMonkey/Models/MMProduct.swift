//
//  MMProduct.swift
//  MateMonkey
//
//  Created by Peter on 12.06.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation

class MMProduct {
    let name: String
    let id: Int
    let type: String
    let slug: String
    
    init(name: String, id: Int, type: String, slug: String) {
        self.name = name
        self.id = id
        self.type = type
        self.slug = slug
    }
    
    // JSON initializer
    init(json: [String:Any]) throws {
        
        // Extract name
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        // Extract id
        guard let id = json["id"] as? Int else {
            throw SerializationError.missing("id")
        }

        // Extract type
        guard let type = json["type"] as? String else {
            throw SerializationError.missing("type")
        }

        // Extract slug
        guard let slug = json["slug"] as? String else {
            throw SerializationError.missing("slug")
        }
        
        self.name = name
        self.id = id
        self.type = type
        self.slug = slug
    }
    
    
    enum SerializationError: Error {
        case missing(String)
    }
}
