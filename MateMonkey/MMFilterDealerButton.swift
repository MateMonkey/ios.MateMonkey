//
//  MMFilterButton.swift
//  MateMonkey
//
//  Created by Peter on 26.03.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import UIKit

class MMFilterDealerButton: UIButton {
    
    var filterSelected: Bool = true {
        didSet {
            updateButtonSettings()
        }
    }
    
    var typeTag: MMDealerType?
    
    var color: UIColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0) {
        didSet {
            updateButtonSettings()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateButtonSettings() {
        if self.filterSelected {
            self.backgroundColor = self.color
        } else {
            self.backgroundColor = desaturateColor(self.color)
            if (self.typeTag == .restaurant || self.typeTag == .bar || self.typeTag == .hackerspace || self.typeTag == .club) {
                self.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
        }
    }
    
    func desaturateColor(_ color: UIColor) -> UIColor {
        // shamelessly copied from https://gist.github.com/soffes/68d355e828cb502f75c3b8f989962958
        var hue: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getHue(&hue, saturation: nil, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: 0, brightness: brightness, alpha: alpha)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
