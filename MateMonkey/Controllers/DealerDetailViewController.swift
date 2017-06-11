//
//  DealerDetailViewController.swift
//  MateMonkey
//
//  Created by Peter on 04.02.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import UIKit
import MessageUI

class DealerDetailViewController: UIViewController {
    
    // MARK: Structs
    
    private enum ContactError{
        case invalidPhone, invalidURL
    }
    
    // MARK: - Outlets
    @IBOutlet weak var dealerNameLabel: UILabel!
    @IBOutlet weak var streetNameLabel: UILabel!
    @IBOutlet weak var streetNumberLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dealerTypeLabel: UILabel!
    
    
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var emailAddressButton: UIButton!
    @IBOutlet weak var websiteAddressButton: UIButton!

    @IBOutlet weak var notesLabel: UILabel!
    
    @IBOutlet weak var stockTableView: UITableView!
    
    
    // MARK: - Variables
    var dealerToDisplay: MMDealer?
    
    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let dealer = dealerToDisplay {
            populateLabelsForDealer(dealer)
        }
        
        stockTableView.dataSource = self

        /* Experimental navBar colors
         self.navigationController?.navigationBar.barTintColor = UIColor.monkeyGreenDark()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func closeBarButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func phoneNumberPressed(_ sender: UIButton) {
        if let phoneNumber = dealerToDisplay?.address.phone {
            let phoneString = "tel://" + sanitizedPhoneNumber(phoneNumber)
            if let phoneURL = URL(string: phoneString) {
                if UIApplication.shared.canOpenURL(phoneURL) {
                    let phoneConfirmationAlert: UIAlertController = UIAlertController(title: VisibleStrings.callAlertTitle, message: VisibleStrings.callAlertMessage, preferredStyle: .alert)
                    phoneConfirmationAlert.addAction(UIAlertAction(title: VisibleStrings.cancel, style: .cancel, handler: nil))
                    phoneConfirmationAlert.addAction(UIAlertAction(title: VisibleStrings.callAlertConfirm, style: .default, handler: { (UIAlertAction) in
                        UIApplication.shared.openURL(phoneURL)
                    }))
                    present(phoneConfirmationAlert, animated: true, completion: nil)
                }
            } else {
                showErrorAlert(forErrorType: .invalidPhone)
            }
        }
    }
    
    @IBAction func emailAddressPressed(_ sender: UIButton) {
        if let emailAddress = dealerToDisplay?.address.email {
            let addressArray = [emailAddress]
            let mailController = MFMailComposeViewController()
            mailController.setToRecipients(addressArray)
            mailController.mailComposeDelegate = self
            
            present(mailController, animated: true, completion: nil)
        }
    }
    
    @IBAction func websiteAddressPressed(_ sender: UIButton) {
        if let webAddress = dealerToDisplay?.address.web {
            if let webURL = URL(string: webAddress) {
                if UIApplication.shared.canOpenURL(webURL) {
                    UIApplication.shared.openURL(webURL)
                }
            } else {
                showErrorAlert(forErrorType: .invalidURL)
            }
        }
    }
    
    
    // MARK: - Functions
    
    func populateLabelsForDealer(_ dealer: MMDealer) {
        dealerNameLabel.text = dealer.name
        streetNameLabel.text = dealer.address.street
        streetNumberLabel.text = dealer.address.number
        postalCodeLabel.text = dealer.address.postal
        cityLabel.text = dealer.address.city
        
        phoneNumberButton.setTitle(dealer.address.phone, for: .normal)
        emailAddressButton.setTitle(dealer.address.email, for: .normal)
        websiteAddressButton.setTitle(dealer.address.web, for: .normal)
        
        notesLabel.text = dealer.note
        
        dealerTypeLabel.text = " " + visibleStringForDealerType(dealer.type) + " "
        dealerTypeLabel.backgroundColor = colorForDealerType(dealer.type)
        
        dealerTypeLabel.layer.masksToBounds = true
        dealerTypeLabel.layer.cornerRadius = 2
    }
    
    private func showErrorAlert(forErrorType errorType: ContactError) {
        var alertMessage: String
        switch errorType {
        case .invalidPhone:
            alertMessage = VisibleStrings.invalidPhoneMessage
        case . invalidURL:
            alertMessage = VisibleStrings.invalidURLMessage
        }
        
        let invalidAlert: UIAlertController = UIAlertController(title: VisibleStrings.invalidContactTitle, message: alertMessage, preferredStyle: .alert)
        invalidAlert.addAction(UIAlertAction(title: VisibleStrings.ok, style: .default, handler: nil))
        
        self.present(invalidAlert, animated: true, completion: nil)
    }
    
    private func sanitizedPhoneNumber(_ phoneNumber: String) -> String {
        let removedSpaces = phoneNumber.replacingOccurrences(of: " ", with: "")
        let removedSlashes = removedSpaces.replacingOccurrences(of: "/", with: "")
        let removedBackslashes = removedSlashes.replacingOccurrences(of: "\\", with: "")
        
        let sanitizedNumber = removedBackslashes
        return sanitizedNumber
    }
    
    private func visibleStringForDealerType(_ type: MMDealerType) -> String {
        switch type {
        case .bar:
            return VisibleStrings.dealerTypeBar
        case .club:
            return VisibleStrings.dealerTypeClub
        case .retail:
            return VisibleStrings.dealerTypeRetail
        case .restaurant:
            return VisibleStrings.dealerTypeRestaurant
        case .other:
            return VisibleStrings.dealerTypeOther
        case .hackerspace:
            return VisibleStrings.dealerTypeHackerspace
        case .community:
            return VisibleStrings.dealerTypeCommunity
        }
    }
    
    private func colorForDealerType(_ type: MMDealerType) -> UIColor {
        switch type {
        case .bar:
            return UIColor.dealerTypeBars()
        case .club:
            return UIColor.dealerTypeClubs()
        case .retail:
            return UIColor.dealerTypeRetail()
        case .restaurant:
            return UIColor.dealerTypeRestaurants()
        case .other:
            return UIColor.dealerTypeOther()
        case .hackerspace:
            return UIColor.dealerTypeHackerspaces()
        case .community:
            return UIColor.dealerTypeCommunity()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let editVC = segue.destination as? EditDealerViewController {
            editVC.dealerToEdit = self.dealerToDisplay
            editVC.JSONsender.delegate = self
        }
    }

}

extension DealerDetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Not much to do here except dismiss the VC (we don't care whatever the user did)
        self.dismiss(animated: true, completion: nil)
    }
}

extension DealerDetailViewController: JSONSenderDelegate {
    func requestCompleted(success: Bool, updatedDealer: MMDealer?) {
        if success {
            // Update the information of the current dealer to reflect the changes.
            DispatchQueue.main.async {
                self.dealerToDisplay = updatedDealer
                if let dealer = self.dealerToDisplay {
                    self.populateLabelsForDealer(dealer)
                }
                if let presenter = self.presentingViewController as? MateMapViewController {
                    presenter.showBanner(withMessage: VisibleStrings.bannerMessageDealerUpdated)
                }
            }
        } else {
            if let presenter = self.presentingViewController as? MateMapViewController {
                presenter.showBanner(withMessage: VisibleStrings.bannerMessageDealerUpdateFailed)
            }
        }
    }
}

extension DealerDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
