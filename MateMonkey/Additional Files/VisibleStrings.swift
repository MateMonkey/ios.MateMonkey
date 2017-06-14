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
    
    // MARK: - Invalid contact detail alert
    static let invalidContactTitle = NSLocalizedString("Error", comment: "Title for an alert that shows when some contact information is invalid.")
    static let invalidPhoneMessage = NSLocalizedString("This phone number is not valid.\nYou can help fix it by editing this dealer.", comment: "Message for an alert that shows when the phone number is invalid.")
    static let invalidURLMessage = NSLocalizedString("This URL is not valid.\nYou can help fix it by editing this dealer.", comment: "Message for an alert that shows when the URL is invalid.")
        
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
    
    // MARK: - Feedback email
    static let feedbackSubject = NSLocalizedString("Matemonkey Feedback", comment: "The subject line for an email with feedback the user can send.")
    
    // MARK: - Dealer types
    static let dealerTypeBar = NSLocalizedString("Bar/Café", comment: "User facing String for dealer types.")
    static let dealerTypeClub = NSLocalizedString("Club", comment: "User facing String for dealer types.")
    static let dealerTypeRetail = NSLocalizedString("Retail", comment: "User facing String for dealer types.")
    static let dealerTypeRestaurant = NSLocalizedString("Restaurant", comment: "User facing String for dealer types.")
    static let dealerTypeOther = NSLocalizedString("Other", comment: "User facing String for dealer types.")
    static let dealerTypeHackerspace = NSLocalizedString("Hackerspace", comment: "User facing String for dealer types.")
    static let dealerTypeCommunity = NSLocalizedString("Community", comment: "User facing String for dealer types.")
    
    // MARK: - Stock information
    static let noStockInformation = NSLocalizedString("No products yet.", comment: "String to show when there are no stock entries for a dealer.")
    
}
