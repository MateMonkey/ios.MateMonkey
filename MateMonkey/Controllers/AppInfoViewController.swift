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
    }
    
    @IBAction func twitterButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func githubButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func guentnerHomepageTapped(_ sender: UIButton) {
    }
    
    @IBAction func hossHomepageTapped(_ sender: UIButton) {
    }
    
    @IBAction func licenseButtonTapped(_ sender: UIButton) {
        // TODO: revisit at a later time and implement necessary information
    }
    
    @IBAction func rateButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func closeBarButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    func setVersionInLabel() {
        if let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let labelString = VisibleStrings.version + " " + versionString
            versionLabel.text = labelString
        }
    }
    
}
