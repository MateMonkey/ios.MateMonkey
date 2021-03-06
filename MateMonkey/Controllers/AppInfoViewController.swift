//
//  AppInfoViewController.swift
//  MateMonkey
//
//  Created by Peter on 28.02.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import UIKit
import MessageUI

class AppInfoViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var versionLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.view.tintColor = UIColor.monkeyGreenDark()
        setVersionInLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func homepageButtonTapped(_ sender: UIButton) {
        openURLFromString(GlobalValues.homepageURL)
    }
    
    @IBAction func twitterButtonTapped(_ sender: UIButton) {
        openURLFromString(GlobalValues.twitterURL)
    }
    
    @IBAction func feedbackButtonTapped(_ sender: UIButton) {
        
        let emailAddress = GlobalValues.feedbackEmail
        let addressArray = [emailAddress]
        let mailController = MFMailComposeViewController()
        mailController.setToRecipients(addressArray)
        mailController.setSubject(VisibleStrings.feedbackSubject)
        mailController.setMessageBody("\n\n\n\n\n" + getDeviceInfoString(), isHTML: false)
        mailController.mailComposeDelegate = self
        
        present(mailController, animated: true, completion: nil)

    }
        
    @IBAction func rateButtonTapped(_ sender: UIButton) {
        openURLFromString(GlobalValues.appStoreReviewURL)
    }
    
    @IBAction func closeBarButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    func setVersionInLabel() {
        if let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let buildString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                let labelString = VisibleStrings.version + " " + versionString + " (" + buildString + ")"
                versionLabel.text = labelString
            }
        }
    }
    
    func openURLFromString(_ string: String) {
        if let url = URL(string: string) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                        success ? print("Opened \(string).") : print("Failed to open \(string).")
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        } else {
            print("Invalid URL: \(string)")
        }
    }
    
    func getDeviceInfoString() -> String {
        if let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let buildString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                let systemName = UIDevice.current.systemName
                let systemVersion = UIDevice.current.systemVersion
                var currentLanguage = "(unknown)"
                if let language = Bundle.main.preferredLocalizations.first {
                    currentLanguage = language
                }
                
                let deviceInfo = "MateMonkey version " + versionString + "(" + buildString + ")\nOperating System: " + systemName + " " + systemVersion + "\nLanguage: " + currentLanguage
                
                return deviceInfo
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}

extension AppInfoViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Not much to do here except dismiss the VC (we don't care whatever the user did)
        self.dismiss(animated: true, completion: nil)
    }
}
