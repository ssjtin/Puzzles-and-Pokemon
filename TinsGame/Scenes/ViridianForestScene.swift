//
//  ViridianForestScene.swift
//  TinsGame
//
//  Created by Hoang Luong on 1/8/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit

class ViridianForestScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        
        sprite.position = tilemap.centerOfTile(atColumn: 10, row: 2)
        sprite.texture = sprite.textureAtlas.textureNamed("character_walk_up_1")
    }
}
