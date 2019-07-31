//
//  HouseInteriorScene.swift
//  TinsGame
//
//  Created by Hoang Luong on 31/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class HouseInteriorScene: SKScene {
    
    var sceneDelegate: GameSceneDelegate?
    
    var tileMap: SKTileMapNode!
    var sprite: SKSpriteNode!
    let sceneCamera = SKCameraNode()
    
    let dpad = DirectionPad()
    
    override func didMove(to view: SKView) {
        
        configureScene()
        configureCamera()
        placeNonPlayableChars()
    }
    
    private func configureScene() {
        if let mainTileMap = childNode(withName: "MainTileMap") as? SKTileMapNode {
            tileMap = mainTileMap
        }
        
        let characterSprite = CharacterSprite(texture: SKTexture(imageNamed: "walk_down_1"), color: .white, size: CGSize(width: 50, height: 50))
        
        addChild(characterSprite)
        sprite = characterSprite
        
    }
    
    private func configureCamera() {
        self.camera = sceneCamera
        addChild(sceneCamera)
        let zeroRange = SKRange(constantValue: 0.0)
        let playerSpriteConstraint = SKConstraint.distance(zeroRange, to: sprite)
        
        sceneCamera.constraints = [playerSpriteConstraint]
        sceneCamera.addChild(dpad)
        dpad.position = CGPoint(x: -size.width/2 * 0.65, y: -size.height/5)
    }
    
    private func placeNonPlayableChars() {
        let mageNPC = NPCSprite(spriteName: "mage", characterName: "HouseGirl1")
        tileMap.addChild(mageNPC)
        let position = tileMap.centerOfTile(atColumn: 3, row: 3)
        mageNPC.position = position
    }
    
}
