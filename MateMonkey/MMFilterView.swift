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
    func presentFromFilterView(viewController: UIViewController)
}

enum FilterButtonType {
    case dealer, products, info, add
}

enum ViewControllerSegueType {
    case filterDealers, filterProducts, appInfo, addDealer
}

class MMFilterView: UIView {
    
    // MARK: Variables
    let width: CGFloat
    let height: CGFloat
    
    let detailImage = UIImage(named: "CustomDetail")
    let addImage = UIImage(named: "AddButton")
    
    public var delegate: MMFilterViewDelegate?
    
    var lastLocation = CGPoint(x: 0, y: 0)
    
    // MARK: Buttons
    let expanderImageView: UIImageView
    let filterDealersButton: UIButton
    let filterProductsButton: UIButton
    let infoButton: UIButton
    let addDealerButton: UIButton
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        self.width = frame.width
        self.height = frame.height
        
        expanderImageView = UIImageView(image: UIImage(named: "Expander")!)
        filterDealersButton = UIButton(type: .custom)
        filterProductsButton = UIButton(type: .custom)
        
        infoButton = UIButton(type: .custom)
        addDealerButton = UIButton(type: .custom)
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.monkeyGreenDark()
        self.layer.cornerRadius = GlobalValues.FVCornerRadius

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(detectPan))
        self.gestureRecognizers = [panRecognizer]
        
        expanderImageView.frame = CGRect(x: 0, y: 0, width: width, height: GlobalValues.FVExpanderHeight)
        self.addSubview(expanderImageView)
        
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
        case .dealer:
            button.setTitle(VisibleStrings.filterDealers, for: .normal)
            button.frame = CGRect(x: width * GlobalValues.FVButtonInsetFactor, y: GlobalValues.FVDealerButtonY, width: width * GlobalValues.FVButtonWidthFactor, height: GlobalValues.FVFilterButtonHeight)
            button.layer.borderWidth = GlobalValues.FVButtonBorderWidth
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.cornerRadius = GlobalValues.FVCornerRadius
            button.addTarget(self, action: #selector(openDealersFilter), for: .touchUpInside)
            button.setTitleColor(UIColor.monkeyGreenLight(), for: .highlighted)
        case .products:
            button.setTitle(VisibleStrings.filterProducts, for: .normal)
            button.frame = CGRect(x: width * GlobalValues.FVButtonInsetFactor, y: GlobalValues.FVProductButtonY, width: width * GlobalValues.FVButtonWidthFactor, height: GlobalValues.FVFilterButtonHeight)
            button.layer.borderWidth = GlobalValues.FVButtonBorderWidth
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.cornerRadius = GlobalValues.FVCornerRadius
            button.addTarget(self, action: #selector(openProductsFilter), for: .touchUpInside)
            button.setTitleColor(UIColor.monkeyGreenLight(), for: .highlighted)
        case .info:
            button.frame = CGRect(x: width * GlobalValues.FVButtonInsetFactor, y: GlobalValues.FVDoubleButtonsY, width: GlobalValues.FVDoubleButtonsWidth, height: GlobalValues.FVDoubleButtonsHeight)
            button.setImage(detailImage, for: .normal)
            button.addTarget(self, action: #selector(openInfoScreen), for: .touchUpInside)
        case .add:
            button.frame = CGRect(x: (width * GlobalValues.FVButtonRightInsetFactor) - GlobalValues.FVDoubleButtonsWidth, y: GlobalValues.FVDoubleButtonsY, width: GlobalValues.FVDoubleButtonsWidth, height: GlobalValues.FVDoubleButtonsHeight)
            button.setImage(addImage, for: .normal)
            button.addTarget(self, action: #selector(addDealer), for: .touchUpInside)
        }
        
        self.addSubview(button)
    }
    
    func detectPan(recognizer: UIPanGestureRecognizer) {
        let translation: CGPoint = recognizer.translation(in: self.superview)
        
        switch recognizer.state {
        case .began:
            // Set and remember the view's last location in the variable
            lastLocation = self.center
        case .changed:
            // lets move the view
            var newCenter = CGPoint(x: lastLocation.x, y: lastLocation.y + translation.y)
            
            // Add a "rubber band" effect here, so the user can't pull up indefinitely.
            // It's ok for now, but some minor tweaking wouldn't hurt either.
            let myLogForY = translation.y / log10(abs(translation.y))
            newCenter.y = lastLocation.y + myLogForY
            
            self.center = newCenter
        case .ended:
            // check the location and snap to a state
            var newCenter = CGPoint(x: lastLocation.x, y: lastLocation.y + translation.y)
            if newCenter.y >= UIScreen.main.bounds.height {
                newCenter.y = UIScreen.main.bounds.height + GlobalValues.FVContentCenterOffset
            } else {
                newCenter.y = UIScreen.main.bounds.height - GlobalValues.FVContentCenterOffset - GlobalValues.FVBottomButtonPadding
            }
            UIView.animate(withDuration: GlobalValues.FVSnapBackAnimationDuration, animations: {
                self.center = newCenter
            })
        default:
            // think about the other possible cases and if we really dont need them.
            print("default")
        }
    }
    
    func openDealersFilter() {
        segueToViewControllerType(.filterDealers)
    }
    
    func openProductsFilter() {
        segueToViewControllerType(.filterProducts)
    }
    
    func openInfoScreen() {
        segueToViewControllerType(.appInfo)
    }
    
    func addDealer() {
        segueToViewControllerType(.addDealer)
    }
    
    func segueToViewControllerType(_ type: ViewControllerSegueType) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        switch type {
        case .filterDealers:
            let filterDealersVC: FilterDealersViewController = mainStoryboard.instantiateViewController(withIdentifier: "FilterDealersView") as! FilterDealersViewController
            delegate?.presentFromFilterView(viewController: filterDealersVC)
        case .filterProducts:
            // TODO: implement this.
            print("Not yet implemented.")
        case .appInfo:
            let appInfoVC: AppInfoViewController = mainStoryboard.instantiateViewController(withIdentifier: "AppInfoView") as! AppInfoViewController
            delegate?.presentFromFilterView(viewController: appInfoVC)
        case .addDealer:
            // TODO: implement this.
            print("Not yet implemented.")
        }
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}
