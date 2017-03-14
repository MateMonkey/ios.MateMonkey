//
//  InternalStrings.swift
//  MateMonkey
//
//  Created by Peter on 30.01.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation
import UIKit

struct GlobalValues {
    
    // MARK: API URL
    #if DEBUG
        static let baseURL: String = "https://playground.matemonkey.com/api/v1/"
    #else
        static let baseURL: String = "https://matemonkey.com/api/v1/"
    #endif
    
    
    // MARK: - Filter View size constants
    
    static let FilterViewHeight: CGFloat = 280
    
    static let FVCornerRadius: CGFloat = 14
    static let FVButtonBorderWidth: CGFloat = 1
    
    static let FVExpanderHeight: CGFloat = 50 // big target for touch
    
    static let FVButtonInsetFactor: CGFloat = 0.09 // The button inset times 2 plus
    static let FVButtonWidthFactor: CGFloat = 0.82 // the button width needs to equal 1.0
    static let FVButtonRightInsetFactor: CGFloat = 1.00 - GlobalValues.FVButtonInsetFactor // The button inset factor for the right side
    
    static let FVFilterButtonHeight: CGFloat = 50.0 // big target for touch
    static let FVDoubleButtonsHeight: CGFloat = 40.0 // just a tad smaller to make hierarchy clear
    static let FVDoubleButtonsWidth: CGFloat = GlobalValues.FVDoubleButtonsHeight // we want them square
    
    static let FVDealerButtonY: CGFloat = 50
    static let FVProductButtonY: CGFloat = 120
    static let FVDoubleButtonsY: CGFloat = 190
    
    static let FVBottomButtonPadding: CGFloat = 15
    
    static let FVContentCenterOffset = (GlobalValues.FilterViewHeight - (GlobalValues.FVExpanderHeight * 2)) / 2
    // Take the overall height (280), substract padding at the top and bottom (2x50 = 100) and divide by two: This will be the content's center.
    
    static let FVSnapBackAnimationDuration: TimeInterval = 0.1
}
