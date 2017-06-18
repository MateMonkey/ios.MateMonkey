//
//  Extensions.swift
//  MateMonkey
//
//  Created by Peter on 22.02.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func monkeyGreenDark() -> UIColor {
        return UIColor(colorLiteralRed: 0.02, green: 0.33, blue: 0.03, alpha: 1.0)
    }
    class func monkeyGreenLight() -> UIColor {
        return UIColor(colorLiteralRed: 0.36, green: 0.72, blue: 0.36, alpha: 1.0)
    }
    
    class func dealerTypeRetail() -> UIColor {
        return UIColor(colorLiteralRed: 114 / 255, green: 176 / 255, blue: 39 / 255, alpha: 1)
    }
    class func dealerTypeBars() -> UIColor {
        return UIColor(colorLiteralRed: 255 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1)
    }
    class func dealerTypeRestaurants() -> UIColor {
        return UIColor(colorLiteralRed: 246 / 255, green: 151 / 255, blue: 47 / 255, alpha: 1)
    }
    class func dealerTypeCommunity() -> UIColor {
        return UIColor(colorLiteralRed: 67 / 255, green: 105 / 255, blue: 120 / 255, alpha: 1)
    }
    class func dealerTypeClubs() -> UIColor {
        return UIColor(colorLiteralRed: 210 / 255, green: 82 / 255, blue: 185 / 255, alpha: 1)
    }
    class func dealerTypeHackerspaces() -> UIColor {
        return UIColor(colorLiteralRed: 56 / 255, green: 170 / 255, blue: 221 / 255, alpha: 1)
    }
    class func dealerTypeOther() -> UIColor {
        return UIColor(colorLiteralRed: 114 / 255, green: 130 / 255, blue: 36 / 255, alpha: 1)
    }

}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}


// We need to convert Strings from the price input in the stock updater view to Floats. Casting a string to Float only works when the decimal separator is a dot (.), a (European) comma (,) does not work. Taken from http://www.howtobuildsoftware.com/index.php/how-do/bdPI/string-comma-swift-playground-swift-playground-how-to-convert-a-string-with-comma-to-a-string-with-decimal
extension String {
    var floatConverter: Float {
        let converter = NumberFormatter()
        converter.decimalSeparator = "."
        if let result = converter.number(from: self) {
            return result.floatValue
        } else {
            converter.decimalSeparator = ","
            if let result = converter.number(from: self) {
                return result.floatValue
            }
        }
        return 0
    }
}
