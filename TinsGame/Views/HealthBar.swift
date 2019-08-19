//
//  HealthBar.swift
//  TinsGame
//
//  Created by Hoang Luong on 29/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit

class HealthBar: SKSpriteNode {
    
    let mainBar = SKSpriteNode()
    
    init(size: CGSize) {
        
        super.init(texture: nil, color: .clear, size: size)
        
        drawBorder(color: .black, width: 3)
        
        mainBar.color = .green
        mainBar.size = CGSize(width: size.width-3, height: size.height-3)
        mainBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        mainBar.zPosition = 10
        mainBar.position = CGPoint(x: -size.width/2, y: 0)
        addChild(mainBar)
    }
    
    func animateTo(percentage: Float, completion: @escaping () -> ()) {
        let scaleAction = SKAction.scaleX(to: CGFloat(percentage), duration: 0.5)
        mainBar.run(scaleAction) {
            completion()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
