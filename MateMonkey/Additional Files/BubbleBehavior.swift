//
//  BubbleBehavior.swift
//  MateMonkey
//
//  Created by Peter on 16.03.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import UIKit

class BubbleBehavior: UIDynamicBehavior {
    
    lazy var gravity: UIGravityBehavior = {
        let lazilyCreatedGravity = UIGravityBehavior()
        return lazilyCreatedGravity
    }()
    
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
    }()
    
    lazy var filterBubbleBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedBubbleBehavior = UIDynamicItemBehavior()
        lazilyCreatedBubbleBehavior.allowsRotation = false
        // TODO: test behaviors like elasticity, friction, resistance.
        return lazilyCreatedBubbleBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(filterBubbleBehavior)
        addChildBehavior(gravity)
    }
    
    func addBubble(_ bubble: UIView) {
        dynamicAnimator?.referenceView?.addSubview(bubble)
        collider.addItem(bubble)
        filterBubbleBehavior.addItem(bubble)
        gravity.addItem(bubble)
    }
}
