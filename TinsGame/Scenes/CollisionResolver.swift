//
//  CollisionResolver.swift
//  TinsGame
//
//  Created by Hoang Luong on 31/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//
enum MovementResult {
    case OutOfBounds
    case Transport
    case Advance
}

class CollisionResolver {
    
    func resultMovingToTile(containing nodesNamed: [String?]) -> (MovementResult, String) {
        
        let actualNodes = nodesNamed.compactMap { $0 }
        
        if let transportNodeName = actualNodes.first(where: {$0.contains("transport")}) {
            return (.Transport, transportNodeName)
        }
        

        if (actualNodes.filter { $0.contains("solid") }).count > 0 {
            return (.OutOfBounds, "")
        }
        

        
        return (.Advance, "")
    }
}
