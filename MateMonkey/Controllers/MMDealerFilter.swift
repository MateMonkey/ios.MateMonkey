//
//  MMDealerFilter.swift
//  MateMonkey
//
//  Created by Peter on 30.03.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//
//  The MMDealerFilter's activeTypes array represents a key value pair for each
//  MMDealerType with an according Bool value. That Bool value is true, if the
//  dealer type should be displayed and false if not.

import Foundation

class MMDealerFilter {
    
    private var activeTypes = [MMDealerType: Bool]()
    private var dealerTypeAsStrings = [MMDealerType.bar, MMDealerType.club, MMDealerType.retail, MMDealerType.restaurant, MMDealerType.other, MMDealerType.hackerspace, MMDealerType.community]
    
    init() {
        updateActiveTypes()
    }
    
    func updateActiveTypes() {
        activeTypes = getActiveTypes()
    }
    
    private func getActiveTypes() -> [MMDealerType: Bool]{
        var activeList = [MMDealerType: Bool]()
        
        for dealerType in dealerTypeAsStrings {
            if isDealerTypeFilteredOut(type: String(describing: dealerType)) {
                activeList.updateValue(false, forKey: dealerType)
            } else {
                activeList.updateValue(true, forKey: dealerType)
            }
        }
        
        return activeList
    }
    
    private func isDealerTypeFilteredOut(type: String) -> Bool {
        let userDefaultKey = "FilterOutDealerType-" + type
        return UserDefaults.standard.bool(forKey: userDefaultKey)
    }
    
    public func getStatusForType(_ type: MMDealerType) -> Bool {
        return activeTypes[type]!
    }
    
    public func setStatus(_ status: Bool, forType type: MMDealerType) {
        let userDefaultKey = "FilterOutDealerType-" + String(describing: type)
        UserDefaults.standard.set(!status, forKey: userDefaultKey)
        updateActiveTypes()
    }
    
}
