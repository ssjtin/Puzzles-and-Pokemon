//
//  NPCSprite.swift
//  TinsGame
//
//  Created by Hoang Luong on 31/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit

struct CharacterAttributes {
    
    let defaultPosition: (col: Int, row: Int)
    let speech: [String]
    let walkPattern: [(Direction, Int)]
}

class NPCSprite: SKSpriteNode {
    
    let spriteName: String
    let characterName: String
    
    let textureAtlas: SKTextureAtlas!
    
    init(spriteName: String, characterName: String) {
        
        self.spriteName = spriteName
        self.characterName = characterName
        textureAtlas = SKTextureAtlas(named: spriteName)
        
        super.init(texture: nil, color: .white, size: CGSize(width: 50, height: 50))
        
        texture = SKTexture(imageNamed: spriteName + "_walk_down_1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
