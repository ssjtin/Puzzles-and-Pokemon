 //
//  BaseScene.swift
//  TinsGame
//
//  Created by Hoang Luong on 31/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

 import SpriteKit
 
 class BaseScene: SKScene {
    
    var gameData: GameData!
    let sounds = MapSound()

    weak var sceneDelegate: GameSceneDelegate?       //Handles presenting scenes
    var tilemap: SKTileMapNode!                 //Reference to base tile map
    var sprite = CharacterSprite()          //Reference to player sprite
    let sceneCamera = SKCameraNode()
    let collisionDetector = CollisionDetector()  //Evaluates what happens at specific map tile
    let dpad = DirectionPad()
    
    override func didMove(to view: SKView) {
        
        //Decode in-game items and npc's from map property list
        if let mapName = self.scene?.name {
            self.gameData = GameData(mapName: mapName)
        }

        if let mainTileMap = childNode(withName: "BaseTileMap") as? SKTileMapNode {
            tilemap = mainTileMap
        }
        tilemap.addChild(sprite)
        
        populateMap()
        
        sprite.position = tilemap.centerOfTile(atColumn: 1, row: 1)
        configureCamera()
        configureDirectionPad()
        
        let bgm = SKAudioNode(fileNamed: "Pallet Town Theme.mp3")
        addChild(bgm)
        
        sprite.position = tilemap.centerOfTile(atColumn: 10, row: 15)
    }
    
    deinit {
        print("deallocating map")
    }
    
    private func populateMap() {
        addNPCs()
        addItems()
    }
    
    private func addNPCs() {
        let npcs = gameData.mapData.npc
        for npc in npcs {
            let sprite = NPCSprite(npc: npc)
            sprite.position = tilemap.centerOfTile(atColumn: npc.startingColumn, row: npc.startingRow)
            tilemap.addChild(sprite)
            sprite.animate()
        }
    }
    
    private func addItems() {
        let items = gameData.mapData.items
        for item in items {
            let itemSprite = ItemSprite(item: item)
            itemSprite.position = tilemap.centerOfTile(atColumn: item.column, row: item.row)
            tilemap.addChild(itemSprite)
        }
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
        
        let movementResult = collisionDetector.resultMovingToTile(atCol: column, row: row, on: tilemap)
        let destination = tilemap.centerOfTile(atColumn: column, row: row)
        
        switch movementResult.0 {
        case .Advance:
            //Move sprite to next tile
            sprite.animateMoving(to: destination, in: movingDirection) { [unowned self] in
                //Check for events before allowing further movement
                if let node = self.nodes(at: self.sprite.position).first(where: { ($0.name ?? "").contains("wildgrass") }) {
                    if self.randomSuccess(withPercentage: 30) {
                        self.handleEncounter(at: node.name!)
                        self.movingDirection = .None
                        return
                    }
                }
                
                if self.movingDirection != .None {
                    self.moveCharacter()
                }
                
            }
                
        case .OutOfBounds:
            // Blocked tile, show only sprite walking animation without advancing
            run(sounds.bumpSound)
            sprite.animateShuffleFootsteps(in: movingDirection) { [unowned self] in
                if self.movingDirection != .None {
                    self.moveCharacter()
                }
            }
        case .Transport:
            sprite.animateMoving(to: destination, in: movingDirection) { [unowned self] in
                let sceneName = movementResult.1
                self.sceneDelegate?.transition(to: sceneName, from: self.view)
            }
            
        }
        
    }
    
    func handleTransition(to sceneNamed: String) {
        sceneDelegate?.transition(to: sceneNamed, from: self.view!)
    }
    
    private func handleEncounter(at nodeNamed: String) {
        
        let encounterSoundEffect = SKAction.playSoundFileNamed("Pokemon encounter.mp3", waitForCompletion: true)
        
        run(encounterSoundEffect) {
            self.sceneDelegate?.presentBattleScene()
        }
    }
    
    func randomSuccess(withPercentage percentage: Int) -> Bool {
        if (arc4random_uniform(100) + 1) <= percentage {
            return true
        }
        return false
    }
    
 }
