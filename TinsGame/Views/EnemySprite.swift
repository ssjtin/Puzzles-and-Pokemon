//
//  EnemySprite.swift
//  TinsGame
//
//  Created by Hoang Luong on 5/8/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit

class EnemyHud: SKNode {
    
    let enemySprite: SKSpriteNode
    let attackLabel = TextLabelNode()
    let healthBar =  HealthBar(size: CGSize(width: healthBarWidth, height: healthBarheight))
    
    init(imageNamed name: String) {
        enemySprite = SKSpriteNode(imageNamed: name)
        enemySprite.size = CGSize(width: 250, height: 250)
        super.init()
        addChild(enemySprite)
        addChild(attackLabel)
        addChild(healthBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateAttack(by pixels: CGFloat, completion: @escaping () -> ()) {
        let origin = position
        let finishPoint = CGPoint(x: position.x - pixels, y: position.y - pixels)
        let toFinish = SKAction.move(to: finishPoint, duration: 0.2)
        let toOrigin = SKAction.move(to: origin, duration: 0.2)
        let sequence = SKAction.sequence([toFinish, toOrigin])
        let repeatAction = SKAction.repeat(sequence, count: 3)
        enemySprite.run(repeatAction) {
            completion()
        }
    }
}
