//
//  MapScene.swift
//  TinsGame
//
//  Created by Hoang Luong on 25/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import SpriteKit

class MapScene: SKScene {
    
    var sceneDelegate: GameSceneDelegate?
    
    var tilemap: SKTileMapNode!
    var sprite: SKSpriteNode!
    
    let sceneCamera = SKCameraNode()
    let collisionResolver = CollisionResolver()
    
    let characterAtlas = SKTextureAtlas(named: "Character")
    
    let dpad = DirectionPad()
    
    private var characterWalkingFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        
        if let grassBackground = childNode(withName: "area-1") as? SKTileMapNode {
            tilemap = grassBackground
        }
        
        if let character = childNode(withName: "character") as? SKSpriteNode {
            sprite = character
        }
        
        configureCamera()
        configureDirectionPad()
    }
    
    deinit {
        print("deallocating map")
    }
    
    private func configureCamera() {
        self.camera = sceneCamera
        addChild(sceneCamera)
        let zeroRange = SKRange(constantValue: 0.0)
        let playerSpriteConstraint = SKConstraint.distance(zeroRange, to: sprite)
        
        sceneCamera.constraints = [playerSpriteConstraint]
    }
    
    private func configureDirectionPad() {
        sceneCamera.addChild(dpad)
        
        dpad.position = CGPoint(x: -size.width/2 * 0.65, y: -size.height/5)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: dpad)
        
        let direction = dpad.direction(from: location)
        
        guard direction != .None else { return }
        movingDirection = direction
        moveCharacter()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: dpad)
        let direction = dpad.direction(from: location)
        
        movingDirection = direction
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingDirection = .None
    }
    
    var movingDirection: Direction = .None
    
    func moveCharacter() {
        
        if sprite.action(forKey: "moving") != nil { return }
        
        let location = sprite.position
        var row = tilemap.tileRowIndex(fromPosition: location)
        var column = tilemap.tileColumnIndex(fromPosition: location)
        
        var walkFrames = [SKTexture]()
        var spriteString = ""
        
        switch movingDirection {
            
        case .Up:   row += 1; spriteString = "walk_up_"
        case .Down: row -= 1; spriteString = "walk_down_"
        case .Left: column -= 1; spriteString = "walk_left_"
        case .Right: column += 1; spriteString = "walk_right_"
        default: return
            
        }
        
        let destination = tilemap.centerOfTile(atColumn: column, row: row)
        let moveAction = SKAction.move(to: destination, duration: 0.3)
        
        
        for i in 1...3 {
            let sprite = spriteString + String(i)
            walkFrames.append(characterAtlas.textureNamed(sprite))
        }
        let walkAnimation = SKAction.animate(with: walkFrames, timePerFrame: 0.1, resize: false, restore: false)
        let nextTilePosition = tilemap.centerOfTile(atColumn: column, row: row)
        let nodeNames = self.nodes(at: nextTilePosition).map { $0.name }
        
        let movementResult = collisionResolver.resultMovingToTile(containing: nodeNames)
        
        switch movementResult.0 {
        case .Advance:
            //Move sprite to next tile
            let group = SKAction.group([walkAnimation, moveAction])
            let completion = SKAction.run {
                if self.movingDirection != .None {
                    self.sprite.removeAllActions()
                    self.moveCharacter()
                }
                if let node = self.nodes(at: self.sprite.position).first(where: { ($0.name ?? "").contains("wildgrass") }) {
                    self.handlePossibleEncounter(at: node.name!)
                }
            }
            let sequence = SKAction.sequence([group, completion])
            sprite.run(sequence, withKey: "moving")
            
        case .OutOfBounds:
            // Blocked tile, show only sprite walking animation without advancing
            sprite.run(walkAnimation)
            
            
        case .Transport:
            sprite.run(walkAnimation) {
                self.handleTransition(to: movementResult.1)
            }
            print(movementResult.1)
        }
        
    }
    
    func handleTransition(to sceneNamed: String) {
        sceneDelegate?.transition(to: sceneNamed, from: self.view!)
    }
    
    private func handlePossibleEncounter(at nodeNamed: String) {
        if randomSuccess(withPercentage: 30) {
            sceneDelegate?.presentBattleScene()
   
        }
    }
    
    func randomSuccess(withPercentage percentage: Int) -> Bool {
        if (arc4random_uniform(100) + 1) <= percentage {
            return true
        }
        
        return false
    }
    
}
