//
//  Item.swift
//  TinsGame
//
//  Created by Hoang Luong on 8/8/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit

class ItemSprite: SKSpriteNode {
    
    let item: Item
    
    init(item: Item) {
        
        self.item = item
        
        super.init(texture: nil, color: .clear, size: CGSize(width: 50, height: 50))
        
        texture = SKTexture(imageNamed: item.spriteName)
        zPosition = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
