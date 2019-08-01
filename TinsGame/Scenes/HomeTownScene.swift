//
//  MapScene.swift
//  TinsGame
//
//  Created by Hoang Luong on 25/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import SpriteKit

class HomeTownScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        sprite.position = tilemap.centerOfTile(atColumn: 10, row: 15)
    }
    
}
