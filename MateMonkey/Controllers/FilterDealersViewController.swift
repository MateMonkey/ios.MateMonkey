//
//  FilterDealersViewController.swift
//  MateMonkey
//
//  Created by Peter on 16.03.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import UIKit

class FilterDealersViewController: UIViewController {

    // MARK: Constants
    
    let bouncer = BubbleBehavior()
    lazy var animator: UIDynamicAnimator = { UIDynamicAnimator(referenceView: self.view) } ()
    
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(bouncer)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let redBubble = addBubbleWithText("Test")
        redBubble.backgroundColor = UIColor.red
        bouncer.addBubble(redBubble)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    func addBubbleWithText(_ text: String) -> UIView {
        let bubbleX = CGFloat(arc4random()).truncatingRemainder(dividingBy: view.bounds.width)
        let bubbleY = CGFloat(arc4random()).truncatingRemainder(dividingBy: view.bounds.height)
        let bubble = UIView(frame: CGRect(x: bubbleX, y: bubbleY, width: 50, height: 50))
        bubble.layer.cornerRadius = bubble.frame.size.width / 2
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: bubble.frame.size.width, height: bubble.bounds.height))
        label.text = text
        label.textAlignment = .center
        label.textColor = UIColor.black
        bubble.addSubview(label)
        
        view.addSubview(bubble)
        return bubble
    }

}
