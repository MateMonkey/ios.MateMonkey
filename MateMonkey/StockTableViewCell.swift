//
//  StockCellTableViewCell.swift
//  MateMonkey
//
//  Created by Peter on 11.06.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPrizeLabel: UILabel!
    @IBOutlet weak var productLastUpdateLabel: UILabel!
    @IBOutlet weak var productAvailabilityImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
