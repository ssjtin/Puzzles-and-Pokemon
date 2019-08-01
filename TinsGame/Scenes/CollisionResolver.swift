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

class CollisionResolver {
    
    func resultMovingToTile(atCol column: Int, row: Int, containing nodes: [SKNode]) -> (MovementResult, String) {
        
        if let solidLayer = nodes.first(where: { $0.name == "SolidLayer" }) as? SKTileMapNode {
            if let definition = solidLayer.tileDefinition(atColumn: column, row: row) {
                if definition.name == "solid" {
                    return (.OutOfBounds, "")
                }
            }
        }
        
        if let transportString = (nodes.compactMap { $0.name }).first(where: { $0.contains("transport") }) {
            return (.Transport, transportString.replacingOccurrences(of: "transport_", with: ""))
        }
        
        return (.Advance, "")
//        print(nodesNamed)
//        let actualNodes = nodesNamed.compactMap { $0 }
//
//        let solidLayer = actualNodes.first(where: { $0})
//
//        if let transportNodeName = actualNodes.first(where: {$0.contains("transport")}) {
//            return (.Transport, transportNodeName)
//        }
//
//
//        if (actualNodes.filter { $0.contains("solid") }).count > 0 {
//            return (.OutOfBounds, "")
//        }
//
//        return (.Advance, "")
    }
}
