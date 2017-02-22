//
//  InternalStrings.swift
//  MateMonkey
//
//  Created by Peter on 30.01.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation

struct GlobalValues {
    
    #if DEBUG
        static let baseURL: String = "https://playground.matemonkey.com/api/v1/"
    #else
        static let baseURL: String = "https://matemonkey.com/api/v1/"
    #endif
}
