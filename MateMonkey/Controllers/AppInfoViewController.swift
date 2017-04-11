//
//  AppInfoViewController.swift
//  MateMonkey
//
//  Created by Peter on 28.02.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import UIKit

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
        
    @IBAction func rateButtonTapped(_ sender: UIButton) {
        // TODO: revisit once iOS 10.3 is released to implement the new rating feature.
        openURLFromString(GlobalValues.appStoreURL)
        
    }

    @IBAction func viewLicensesButtonTapped(_ sender: UIButton) {
        let licenseAlert = UIAlertController(title: VisibleStrings.licenseAlertTitle, message: VisibleStrings.licenseAlertText, preferredStyle: .alert)
        licenseAlert.addAction(UIAlertAction(title: VisibleStrings.ok, style: .default, handler: nil))
        present(licenseAlert, animated: true, completion: nil)
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
    
}
