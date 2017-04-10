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
    
    // MARK: Outlets
    @IBOutlet weak var dealerNameLabel: UILabel!
    @IBOutlet weak var streetNameLabel: UILabel!
    @IBOutlet weak var streetNumberLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var emailAddressButton: UIButton!
    @IBOutlet weak var websiteAddressButton: UIButton!

    @IBOutlet weak var notesLabel: UILabel!
    
    // MARK: - Variables
    var dealerToDisplay: MMDealer?
    
    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let dealer = dealerToDisplay {
            populateLabelsForDealer(dealer)
        }
        

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
            let phoneString = "tel://" + phoneNumber
            if UIApplication.shared.canOpenURL(URL(string: phoneString)!) {
                let phoneConfirmationAlert: UIAlertController = UIAlertController(title: VisibleStrings.callAlertTitle, message: VisibleStrings.callAlertMessage, preferredStyle: .alert)
                phoneConfirmationAlert.addAction(UIAlertAction(title: VisibleStrings.cancel, style: .cancel, handler: nil))
                phoneConfirmationAlert.addAction(UIAlertAction(title: VisibleStrings.callAlertConfirm, style: .default, handler: { (UIAlertAction) in
                    UIApplication.shared.openURL(URL(string: phoneString)!)
                }))
                present(phoneConfirmationAlert, animated: true, completion: nil)
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
            if UIApplication.shared.canOpenURL(URL(string: webAddress)!) {
                UIApplication.shared.openURL(URL(string: webAddress)!)
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
