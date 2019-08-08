//
//  MonstersHud.swift
//  TinsGame
//
//  Created by Hoang Luong on 5/8/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit

class MonstersHud: SKNode {
    
    var monsters = [SKSpriteNode]()
    let healthBar = HealthBar(size: CGSize(width: healthBarWidth, height: healthBarheight))
    
    init(frameWidth: CGFloat) {
        super.init()
        
        for num in -1...1 {
            let size = CGSize(width: frameWidth, height: frameWidth)
            let position = CGPoint(x: frameWidth * CGFloat(num) , y: 0)
            
            let borderNode = SKSpriteNode(color: .yellow, size: size)
            borderNode.drawBorder(color: .blue, width: 2)
            borderNode.position = position
            
            let spriteNode = SKSpriteNode(imageNamed: "pikachu-back")
            spriteNode.size = size
            spriteNode.position = position
            
            addChild(borderNode)
            addChild(spriteNode)
        }
        
        addChild(healthBar)
        healthBar.position = CGPoint(x: 0, y: 100)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
