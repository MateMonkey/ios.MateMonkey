//
//  MMFilterView.swift
//  MateMonkey
//
//  Created by Peter on 17.02.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import UIKit

protocol MMFilterViewDelegate {
    func expandFilter(sender: MMFilterView)
}


class MMFilterView: UIView {
    
    // MARK: Variables
    let width: CGFloat
    let height: CGFloat
        
    public var delegate: MMFilterViewDelegate?
    
    // MARK: Buttons
    let expander: UIButton
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        self.width = frame.width
        self.height = frame.height
        
        expander = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.monkeyGreenDark()
        self.layer.cornerRadius = 14

        setUpExpander()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setUpExpander() {
        expander.setImage(UIImage(named: "Expander"), for: .normal)
        expander.addTarget(self, action: #selector(expandFilterView), for: [.touchUpInside, .touchDragExit])
        self.addSubview(expander)
    }
    
    func expandFilterView() {
        delegate?.expandFilter(sender: self)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}
