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

enum FilterButtonType {
    case expander, dealer, products, info, add
}

class MMFilterView: UIView {
    
    // MARK: Variables
    let width: CGFloat
    let height: CGFloat
    
    let detailImage = UIImage(named: "CustomDetail")
    let addImage = UIImage(named: "AddButton")
    
    public var delegate: MMFilterViewDelegate?
    
    // MARK: Buttons
    let expanderButton: UIButton
    let filterDealersButton: UIButton
    let filterProductsButton: UIButton
    let infoButton: UIButton
    let addDealerButton: UIButton
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        self.width = frame.width
        self.height = frame.height
        
        expanderButton = UIButton(type: .custom)
        filterDealersButton = UIButton(type: .custom)
        filterProductsButton = UIButton(type: .custom)
        
        infoButton = UIButton(type: .custom)
        addDealerButton = UIButton(type: .custom)
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.monkeyGreenDark()
        self.layer.cornerRadius = 14
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandFilterView))
        self.addGestureRecognizer(tap)

        setUpButton(button: expanderButton, type: .expander)
        setUpButton(button: filterDealersButton, type: .dealer)
        setUpButton(button: filterProductsButton, type: .products)
        setUpButton(button: infoButton, type: .info)
        setUpButton(button: addDealerButton, type: .add)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setUpButton(button: UIButton, type: FilterButtonType) {
        switch type {
        case .expander:
            button.frame = CGRect(x: 0, y: 0, width: width, height: 40)
            button.setImage(UIImage(named: "Expander"), for: .normal)
            button.addTarget(self, action: #selector(expandFilterView), for: [.touchUpInside, .touchDragExit])
        case .dealer:
            button.setTitle(VisibleStrings.filterDealers, for: .normal)
            button.frame = CGRect(x: width * 0.09, y: 40, width: width * 0.82, height: 50.0)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.cornerRadius = 14
            button.addTarget(self, action: #selector(openDealersFilter), for: .touchUpInside)
            button.setTitleColor(UIColor.monkeyGreenLight(), for: .highlighted)
        case .products:
            button.setTitle(VisibleStrings.filterProducts, for: .normal)
            button.frame = CGRect(x: width * 0.09, y: 105, width: width * 0.82, height: 50.0)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.cornerRadius = 14
            button.addTarget(self, action: #selector(openProductsFilter), for: .touchUpInside)
            button.setTitleColor(UIColor.monkeyGreenLight(), for: .highlighted)
        case .info:
            button.frame = CGRect(x: width * 0.09, y: 175, width: 40.0, height: 40.0)
            button.setImage(detailImage, for: .normal)
            button.addTarget(self, action: #selector(openInfoScreen), for: .touchUpInside)
        case .add:
            button.frame = CGRect(x: (width * 0.91) - 40, y: 175, width: 40.0, height: 40.0)
            button.setImage(addImage, for: .normal)
            button.addTarget(self, action: #selector(addDealer), for: .touchUpInside)
        }
        
        self.addSubview(button)
    }
    
    func expandFilterView() {
        delegate?.expandFilter(sender: self)
    }
    
    func openDealersFilter() {
        // TODO: segue to the filter dealers view
    }
    
    func openProductsFilter() {
        // TODO: segue to the filter products view
    }
    
    func openInfoScreen() {
        // TODO: segue to the app info screen
    }
    
    func addDealer() {
        // TODO: segue to an empty editDealerViewController to add another dealer
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}
