//
//  FilterDealersViewController.swift
//  MateMonkey
//
//  Created by Peter on 16.03.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import UIKit

class FilterDealersViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var retailButton: MMFilterDealerButton!
    @IBOutlet weak var restaurantsButton: MMFilterDealerButton!
    @IBOutlet weak var barsCafesButton: MMFilterDealerButton!
    @IBOutlet weak var clubsButton: MMFilterDealerButton!
    @IBOutlet weak var communityButton: MMFilterDealerButton!
    @IBOutlet weak var hackerspacesButton: MMFilterDealerButton!
    @IBOutlet weak var otherButton: MMFilterDealerButton!

    // MARK: - Constants
    
    let filter = MMDealerFilter()
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func filterButtonTapped(_ sender: MMFilterDealerButton) {
        sender.filterSelected = !sender.filterSelected
        filter.setStatus(sender.filterSelected, forType: sender.typeTag!)
    }
    
    
    // MARK: - Functions
    
    func setUpButtons() {
        retailButton.color = UIColor.dealerTypeRetail()
        retailButton.typeTag = .retail
        retailButton.filterSelected = filter.getStatusForType(.retail)
        
        restaurantsButton.color = UIColor.dealerTypeRestaurants()
        restaurantsButton.typeTag = .restaurant
        restaurantsButton.filterSelected = filter.getStatusForType(.restaurant)
        
        barsCafesButton.color = UIColor.dealerTypeBars()
        barsCafesButton.typeTag = .bar
        barsCafesButton.filterSelected = filter.getStatusForType(.bar)
        
        clubsButton.color = UIColor.dealerTypeClubs()
        clubsButton.typeTag = .club
        clubsButton.filterSelected = filter.getStatusForType(.club)
        
        communityButton.color = UIColor.dealerTypeCommunity()
        communityButton.typeTag = .community
        communityButton.filterSelected = filter.getStatusForType(.community)
        
        hackerspacesButton.color = UIColor.dealerTypeHackerspaces()
        hackerspacesButton.typeTag = .hackerspace
        hackerspacesButton.filterSelected = filter.getStatusForType(.hackerspace)
        
        otherButton.color = UIColor.dealerTypeOther()
        otherButton.typeTag = .other
        otherButton.filterSelected = filter.getStatusForType(.other)
    }
}
