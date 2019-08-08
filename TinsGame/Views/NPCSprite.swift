//
//  NPCSprite.swift
//  TinsGame
//
//  Created by Hoang Luong on 31/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit

typealias TileCoordinate = (column: Int, row: Int)

extension SKTileMapNode {
    func nextTileCoordinate(from position: CGPoint, inDirection direction: Direction) -> TileCoordinate? {
        var row = tileRowIndex(fromPosition: position)
        var column = tileColumnIndex(fromPosition: position)
        switch direction {
        case .Left: column -= 1
        case .Right: column += 1
        case .Up: row += 1
        case .Down: row -= 1
        default: return nil
        }
        
        //Return nil if "solid" tile present at next position
        if let solidLayer = childNode(withName: "SolidLayer") as? SKTileMapNode {
            if solidLayer.tileDefinition(atColumn: column, row: row)?.name == "solid" {
                return nil
            }
        }
        
        if nodes(at: centerOfTile(atColumn: column, row: row)).contains(where: { $0 is ItemSprite || $0 is CharacterSprite } ) {
            return nil
        }
        
        return (column: column, row: row)
    }
}

struct CharacterAttributes {
    
    let defaultPosition: (col: Int, row: Int)
    let speech: [String]
    let walkPattern: [(Direction, Int)]
}

class NPCSprite: CharacterSprite {
    
    let npc: NPC
    var coordinate: TileCoordinate    //Describe a rectangle of possible movement
    
    init(npc: NPC) {
        
        self.npc = npc
        self.coordinate = (npc.startingColumn, npc.startingRow)
        
        super.init(textureName: npc.spriteName)
        texture = SKTexture(imageNamed: npc.spriteName + "_walk_down_1")
    }
    
    func animate() {
        //character move randomly within allowed rectangle
        //var nextPosition: CGPoint?
        if let tileMap = parent as? SKTileMapNode {
            let direction = Direction.randomDirection()
            if let nextTileCoordinate = tileMap.nextTileCoordinate(from: position, inDirection: direction) {
                let nextPosition = tileMap.centerOfTile(atColumn: nextTileCoordinate.column, row: nextTileCoordinate.row)
                animateMoving(to: nextPosition, in: direction) {
                    self.animate()
                }
            } else {
                run(SKAction.wait(forDuration: 3.6)) {
                    self.animate()
                }
            }

        }
    }
    
    override func animateMoving(to destination: CGPoint, in direction: Direction, completion: @escaping () -> ()) {
        
        guard direction != .None else { completion(); return }
        
        let walkFrames = getWalkFrames(for: direction)
        let moveAction = SKAction.move(to: destination, duration: 1.8)
        let walkAnimation = SKAction.animate(with: walkFrames, timePerFrame: 0.6, resize: false, restore: false)
        let delayAction = SKAction.wait(forDuration: 3.6)
        let group = SKAction.group([walkAnimation, moveAction, delayAction])
        run(group) {
            completion()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
