//
//  SKSpriteNode_Extension.swift
//  TinsGame
//
//  Created by Hoang Luong on 24/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    
    func drawBorder(color: UIColor, width: CGFloat) {
        let shapeNode = SKShapeNode(rect: frame)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = width
        addChild(shapeNode)
    }
    
}
