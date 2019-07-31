//
//  DirectionPad.swift
//  TinsGame
//
//  Created by Hoang Luong on 29/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit

enum Direction {
    case None, Left, Right, Up, Down
}

class DirectionPad: SKSpriteNode {
    
    init() {
        super.init(texture: nil, color: .clear, size: CGSize(width: directionPadWidth, height: directionPadWidth))
        
        zPosition = 100
        texture = SKTexture(imageNamed: "directionPad")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func direction(from touchLocation: CGPoint) -> Direction {
 
        let x = touchLocation.x
        let y = touchLocation.y

        if x > -35 && x < 35 {
            if 25 < y && y < 100 {
                return .Up
            } else if -25 > y && y > -100 {
                return .Down
            }
        }
        
        if -35 < y && y < 35 {
            if -25 > x && x > -100 {
                return .Left
            } else if 25 < x && x < 100 {
                return .Right
            }
        }
        
        return .None
    }
}
