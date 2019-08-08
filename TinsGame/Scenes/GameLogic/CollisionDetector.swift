//
//  CollisionResolver.swift
//  TinsGame
//
//  Created by Hoang Luong on 31/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit
enum MovementResult {
    case OutOfBounds
    case Transport
    case Advance
}

class CollisionDetector {
    
    //TODO: detect if npc is en route to a tile, currently lets character move to that tile leading to glitch
    
    func resultMovingToTile(atCol column: Int, row: Int, on tileMap: SKTileMapNode) -> (MovementResult, String) {
        
        if let solidLayer = tileMap.childNode(withName: "SolidLayer") as? SKTileMapNode {
            if solidLayer.tileDefinition(atColumn: column, row: row)?.name == "solid" {
                return (.OutOfBounds, "")   
            }
        }
        
        let nodes = tileMap.nodes(at: tileMap.centerOfTile(atColumn: column, row: row))
        if nodes.contains(where: { $0 is ItemSprite || $0 is CharacterSprite }) {
            return (.OutOfBounds, "")
        }
        
        let point = tileMap.centerOfTile(atColumn: column, row: row)
        if let _ = tileMap.nodes(at: point).first(where: { $0 is CharacterSprite }) {
            return (.OutOfBounds, "")  //solid character present
        }
        
        if let transportString = (tileMap.nodes(at: point).compactMap { $0.name }).first(where: { $0.contains("transport") }) {
            return (.Transport, transportString.replacingOccurrences(of: "transport_" ,with: ""))
        }
        
        return (.Advance, "")
    }
}
