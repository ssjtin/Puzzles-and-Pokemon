 //
//  BaseScene.swift
//  TinsGame
//
//  Created by Hoang Luong on 31/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

 import SpriteKit
 
 class BaseScene: SKScene {

    weak var sceneDelegate: GameSceneDelegate?       //Handles presenting scenes
    var tilemap: SKTileMapNode!                 //Reference to base tile map
    var sprite = CharacterSprite()          //Reference to player sprite
    let sceneCamera = SKCameraNode()
    let collisionResolver = CollisionResolver()  //Evaluates what happens at specific map tile
    let dpad = DirectionPad()
    
    override func didMove(to view: SKView) {

        if let mainTileMap = childNode(withName: "BaseTileMap") as? SKTileMapNode {
            tilemap = mainTileMap
        }
        addChild(sprite)
        
        sprite.position = tilemap.centerOfTile(atColumn: 1, row: 1)
        configureCamera()
        configureDirectionPad()
    }
    
    deinit {
        print("deallocating map")
    }
    
    //Add skCamera to scene and configure it to keep character sprite in center of screen
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
        
        if sprite.action(forKey: "movingCharacter") != nil { return }        //Return if currently moving sprite
        
        let location = sprite.position
        var row = tilemap.tileRowIndex(fromPosition: location)
        var column = tilemap.tileColumnIndex(fromPosition: location)
        
        if movingDirection == .Left {
            column -= 1
        } else if movingDirection == .Right {
            column += 1
        } else if movingDirection == .Up {
            row += 1
        } else if movingDirection == .Down {
            row -= 1
        }
        
        let destination = tilemap.centerOfTile(atColumn: column, row: row)
        
        let nodes = self.nodes(at: destination)
        let movementResult = collisionResolver.resultMovingToTile(atCol: column, row: row, containing: nodes)
        
        switch movementResult.0 {
        case .Advance:
            //Move sprite to next tile
            sprite.animateMoving(to: destination, in: movingDirection) { [unowned self] in
                //Check for events before allowing further movement
                if let node = self.nodes(at: self.sprite.position).first(where: { ($0.name ?? "").contains("wildgrass") }) {
                    self.handlePossibleEncounter(at: node.name!)
                    
                } else if self.movingDirection != .None {
                    self.moveCharacter()
                }
                
            }
                
        case .OutOfBounds:
            // Blocked tile, show only sprite walking animation without advancing
            sprite.animateShuffleFootsteps(in: movingDirection) { [unowned self] in
                if self.movingDirection != .None {
                    self.moveCharacter()
                }
            }
        case .Transport:
            sprite.animateShuffleFootsteps(in: movingDirection) { [unowned self] in
                let sceneName = movementResult.1
                self.sceneDelegate?.transition(to: sceneName, from: self.view)
            }
            
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
