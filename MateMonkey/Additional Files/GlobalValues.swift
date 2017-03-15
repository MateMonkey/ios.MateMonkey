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
    
    // MARK: URLs
    #if DEBUG
        static let baseURL: String = "https://playground.matemonkey.com/api/v1/"
    #else
        static let baseURL: String = "https://matemonkey.com/api/v1/"
    #endif
    
    static let homepageURL: String = "https://matemonkey.com"
    static let twitterURL: String = "https://twitter.com/matemonkeycom"
    static let githubURL: String = "https://github.com/MateMonkey"
    static let guentnerURL: String = "https://sourcediver.org" // TODO: ask if this is wanted/the right one.
    static let hossURL: String = "http://www.jurassicturtle.com"
    static let appStoreURL: String = "itms-apps://itunes.apple.com/app/id1202602103"
    
    
    // MARK: - Filter View size constants
    
    static let FilterViewHeight: CGFloat = GlobalValues.FVExpanderHeight + (GlobalValues.FVFilterButtonHeight * 2) + (GlobalValues.FVSpaceBetweenButtons * 2) + GlobalValues.FVDoubleButtonsHeight + GlobalValues.FVBottomViewPadding
    
    static let FVCornerRadius: CGFloat = 14
    static let FVButtonBorderWidth: CGFloat = 1
    
    static let FVExpanderHeight: CGFloat = 50 // big target for touch
    
    static let FVButtonInsetFactor: CGFloat = 0.09
    static let FVButtonWidthFactor: CGFloat = 1.0 - (GlobalValues.FVButtonInsetFactor * 2) // What's left of the button after subtracting the inset from both sides
    static let FVButtonRightInsetFactor: CGFloat = 1.0 - GlobalValues.FVButtonInsetFactor // The button inset factor for the right side
    
    static let FVFilterButtonHeight: CGFloat = 50.0 // big target for touch
    static let FVDoubleButtonsHeight: CGFloat = 40.0 // just a tad smaller to make hierarchy clear
    static let FVDoubleButtonsWidth: CGFloat = GlobalValues.FVDoubleButtonsHeight // we want them square
    
    static let FVDealerButtonY: CGFloat = 0 + GlobalValues.FVExpanderHeight
    static let FVProductButtonY: CGFloat = GlobalValues.FVDealerButtonY + GlobalValues.FVFilterButtonHeight + GlobalValues.FVSpaceBetweenButtons
    static let FVDoubleButtonsY: CGFloat = GlobalValues.FVProductButtonY + GlobalValues.FVFilterButtonHeight + GlobalValues.FVSpaceBetweenButtons
    
    static let FVSpaceBetweenButtons: CGFloat = 15
    static let FVBottomViewPadding: CGFloat = 50
    static let FVBottomButtonPadding: CGFloat = 15
    
    static let FVContentCenterOffset = (GlobalValues.FilterViewHeight - (GlobalValues.FVExpanderHeight * 2)) / 2
    // Take the overall height (280), substract padding at the top and bottom (2x50 = 100) and divide by two: This will be the content's center.
    
    static let FVSnapBackAnimationDuration: TimeInterval = 0.1
}
