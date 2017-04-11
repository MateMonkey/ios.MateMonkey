//
//  VisibleStrings.swift
//  MateMonkey
//
//  Created by Peter on 04.02.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import Foundation

struct VisibleStrings {
    
    // MARK: - Alert Buttons
    static let cancel = NSLocalizedString("Cancel", comment: "Generic cancel for use in an alert.")
    static let ok = NSLocalizedString("OK", comment: "Generic OK for use in an alert.")

    // MARK: - Call Alert
    static let callAlertTitle = NSLocalizedString("Make a phone call", comment: "Title for an alert when the user is about to make a phone call.")
    static let callAlertMessage = NSLocalizedString("Do you want to call this dealer?", comment: "Message for an alert when the user is about to make a phone call.")
    static let callAlertConfirm = NSLocalizedString("Call", comment: "Call confirmation action for an alert when the user is about to make a phone call.")
    
    // MARK: - Missing Field Alert
    static let missingFieldAlertTitle = NSLocalizedString("Missing Entry", comment: "Title for an alert when a required field for a dealer is empty.")
    static let missingFieldAlertMessage = NSLocalizedString("This field can not be empty: ", comment: "Message for an alert when a required field for a dealer is empty.")
    
    static let missingName = NSLocalizedString("Name", comment: "Reason for an alert when the user does not provide a required field: dealer name")
    static let missingStreet = NSLocalizedString("Street", comment: "Reason for an alert when the user does not provide a required field: street name")
    static let missingCountry = NSLocalizedString("Country", comment: "Reason for an alert when the user does not provide a required field: country")
    static let missingCity = NSLocalizedString("City", comment: "Reason for an alert when the user does not provide a required field: city")
    static let missingPostal = NSLocalizedString("ZIP Code", comment: "Reason for an alert when the user does not provide a required field: postal")
    
    // MARK: - License Alert
    static let licenseAlertTitle = NSLocalizedString("Licenses", comment: "Title for an alert that shows all third party libraries and their licenses.")
    static let licenseAlertText = NSLocalizedString("MateMonkey uses the following third party libraries.\n\n∙BRYXBanner (https://github.com/bryx-inc/BRYXBanner):\n Copyright (c) 2015 Harlan Haskins <harlan@harlanhaskins.com>\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.", comment: "Alert content that shows all third party libraries and their licenses.")
    
    // MARK: - Text for FilterView
    static let filterDealers = NSLocalizedString("Filter Dealers", comment: "Title text for the button leading to filtering options for the dealers.")
    static let filterProducts = NSLocalizedString("Filter Products", comment: "Title text for the button leading to filtering options for the products.")
    
    // MARK: - Text for AppInfoScreen
    static let version = NSLocalizedString("Version", comment: "Used to display the app's current version in the AppInfoViewController")
    
    // MARK: - Text for EditDealerView
    static let addDealerTitle = NSLocalizedString("Add Dealer", comment: "Title for the app's screen that lets users add a new dealer.")
    
    // MARK: - Banner texts
    static let bannerMessageNoDealers = NSLocalizedString("There are no dealers in this area.", comment: "Message displayed in a banner at the top of the screen when the current map area has no dealers.")
    static let bannerMessageTooManyDealers = NSLocalizedString("Too many dealers, please zoom in.", comment: "Message displayed in a banner at the top of the screen when there are too many dealers on the map.")
    static let bannerMessageAllFiltered = NSLocalizedString("There are no dealers matching your filters.", comment: "Message displayed in a banner at the top of the screen when there are dealers, but they get sorted out by the user's filters.")
    static let bannerTapToDismiss = NSLocalizedString("(Tap to dismiss)", comment: "Banner subtitle to let the user know how to get rid of the banner quickly.")
    
    static let bannerMessageDealerUpdated = NSLocalizedString("Dealer successfully updated.", comment: "Message displayed in a banner at the top of the screen when a dealer's information has been updated.")
    static let bannerMessageDealerUpdateFailed = NSLocalizedString("Dealer could not be updated.", comment: "Message displayed in a banner at the top of the screen when a dealer's information failed to update.")
    
}
