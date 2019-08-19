//
//  TextLabelNode.swift
//  TinsGame
//
//  Created by Hoang Luong on 29/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit

class TextLabelNode: SKLabelNode {
    
    override init() {
        super.init()
        
        alpha = 0
        fontColor = .black
        
    }
    
    func animateFlash(times: Int, duration: TimeInterval, completion: @escaping () -> ()) {
        let time = duration/6
        let fadeIn = SKAction.fadeIn(withDuration: time)
        let fadeOut = SKAction.fadeOut(withDuration: time)
        let sequence = SKAction.sequence([fadeIn, fadeOut])
        let loop = SKAction.repeat(sequence, count: 3)
        
        self.run(loop, completion: completion)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
