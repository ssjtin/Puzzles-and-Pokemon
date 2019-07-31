//
//  GameScene.swift
//  TinsGame
//
//  Created by Hoang Luong on 21/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class BattleScene: SKScene {
    
    var level = Level()                //Level class controls puzzle orbs
    let gameSound = GameSound()         //Preload game sounds
    
    var sceneDelegate: GameSceneDelegate?
    var encounter: Encounter!
    
    //Orb handling logic variables
    var swipedOrbs: [(column: Int, row: Int)] = [] {
        didSet {
            if self.swipedOrbs.count == 1 && isSwiping == false {
                if let handler = resolveMatchesHandler {
                    handler()
                }
            }
        }
    }
    var isSwiping: Bool = false
    var activeOrb: SKSpriteNode?
    var initialOrb: SKSpriteNode?
    
    //Combo variables
    var comboCount: Int = 0
    var comboChains: [Chain] = []
    
    //Scene layers
    let gameLayer = SKNode()
    let tilesLayer = SKNode()
    //Layer that holds the orbs
    let orbsLayer = SKNode()
    
    //Character and battle layer
    let fightStageLayer = SKNode()
    let playerCharactersLayer = SKNode()
    
    //Health bars
    let enemyHealthBar = HealthBar(size: CGSize(width: healthBarWidth, height: healthBarheight))
    let playerHealthBar = HealthBar(size: CGSize(width: healthBarWidth, height: healthBarheight))

    //Text labels
    let attackLabel = TextLabelNode()
    
    //Delegate closures
    var swipeHandler: ((Swap) -> Void)?
    var resolveMatchesHandler: (() -> Void)?
    
    override init(size: CGSize) {
        super.init(size: size)
        
        //Set scene anchorPoint to centre of screen
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        setBackgroundImage()
        configureMainLayers()
        
        addTiles()
        
        configureHeroCharacterWindows()
        configureAttackLabel()
        
        let newOrbs = level.shuffle()
        addSprites(for: newOrbs)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBackgroundImage() {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = size
        
        addChild(background)
    }
    
    private func configureMainLayers() {
        //Set origin point for orbs and tiles
        let layerPosition = CGPoint(
            x: 25,
            y: -tileHeight*2.5)
        //Add child layers to parents
        addChild(gameLayer)
        orbsLayer.position = layerPosition
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        gameLayer.addChild(orbsLayer)
        
        //Configure character stage position
        let stagePosition = CGPoint(x: -size.width/4, y: 0)
        fightStageLayer.position = stagePosition
        gameLayer.addChild(fightStageLayer)
        fightStageLayer.addChild(playerCharactersLayer)
    }
    
    private func configureHeroCharacterWindows() {
        
        playerHealthBar.position = CGPoint(x: -40, y: -75)
        fightStageLayer.addChild(playerHealthBar)
        
        for num in -1...1 {
            let size = CGSize(width: characterWindowWidth, height: characterWindowWidth)
            let position = CGPoint(x: -(characterWindowWidth + 10) * CGFloat(num) - 40 , y: -140)
            
            let borderNode = SKSpriteNode(color: .yellow, size: size)
            borderNode.drawBorder(color: .blue, width: 2)
            borderNode.position = position
            
            let spriteNode = SKSpriteNode(imageNamed: "pikachu-back")
            spriteNode.size = size
            spriteNode.position = position
            
            playerCharactersLayer.addChild(borderNode)
            playerCharactersLayer.addChild(spriteNode)
        }
    }
    
    private func configureAttackLabel() {
        attackLabel.position = CGPoint(x: 0, y: 170)
        attackLabel.text = "Burn for a thousand years!!!"
        fightStageLayer.addChild(attackLabel)
    }
    
    func configureEnemy() {
        let enemySprite = SKSpriteNode(imageNamed: encounter.enemyMonsters.baseMonster.images.frontImage!)
        enemySprite.size = CGSize(width: 250, height: 250)
        enemySprite.position = CGPoint(x: 100, y: 50)
        
        fightStageLayer.addChild(enemySprite)
        
        enemyHealthBar.position = CGPoint(x: 100, y: 160)
        fightStageLayer.addChild(enemyHealthBar)
    }
    
    func addTiles() {
        for column in 0..<numColumns {
            for row in 0..<numRows {
                let tile = SKSpriteNode(imageNamed: "Tile_15")
                tile.size = CGSize(width: tileWidth, height: tileHeight)
                tile.position = pointFor(column: column, row: row)
                tilesLayer.addChild(tile)
                
                if (column+row).isMultiple(of: 2) {
                    tile.alpha = 0.25
                } else {
                    tile.alpha = 0.5
                }

            }
        }
    }
    
    func addSprites(for orbs: Set<Orb>) {
        for orb in orbs {
            let sprite = SKSpriteNode(imageNamed: orb.element.spriteName)
            sprite.size = CGSize(width: tileWidth, height: tileHeight)
            sprite.position = pointFor(column: orb.column, row: orb.row)
            orbsLayer.addChild(sprite)
            orb.sprite = sprite
        }
    }
    
    private func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * tileWidth + tileWidth / 2,
            y: CGFloat(row) * tileHeight + tileHeight / 2)
    }
    
    //Touches methods
    
    //Converts touch location to orb? or invalid
    private func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(numColumns) * tileWidth && point.y >= 0 && point.y < CGFloat(numRows) * tileHeight {
            return (true, Int(point.x / tileWidth), Int(point.y / tileHeight))
        } else {
            return (false, 0, 0) // invalid location
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        swipedOrbs.removeAll()
        isSwiping = true
        
        let location = touch.location(in: orbsLayer)
        
        let (success, column, row) = convertPoint(location)
        
        if success {    //Initial touch successfully mapped to valid orb
            if let orb = level.orb(atColumn: column, row: row) {
                initialOrb = orb.sprite
                initialOrb?.alpha = 0
                swipedOrbs.append((column, row))
                activeOrb = SKSpriteNode(imageNamed: orb.element.spriteName)
                activeOrb?.size = CGSize(width: 65, height: 65)
                orbsLayer.addChild(activeOrb!)
                activeOrb?.position = location
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Escape if first touch was not a valid orb
        guard let orb = swipedOrbs.last else { return }
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: orbsLayer)
        activeOrb?.position = location
        
        let (success, column, row) = convertPoint(location)
        if success {
            
            var horizontalDelta = 0, verticalDelta = 0
            if column+1 == orb.column {
                horizontalDelta = -1        // swiped left
            } else if column-1 == orb.column {
                horizontalDelta = 1         // swiped right
            } else if row+1 == orb.row {
                verticalDelta = -1          // swiped down
            } else if row-1 == orb.row {
                verticalDelta = 1           // swiped up
            }
            
            if horizontalDelta != 0 || verticalDelta != 0 {
                
                let toColumn = orb.column + horizontalDelta
                let toRow = orb.row + verticalDelta
                
                guard toColumn >= 0 && toColumn < numColumns else { return }
                guard toRow >= 0 && toRow < numRows else { return }
                
                swipedOrbs.append((toColumn, toRow))
                
                if swipedOrbs.count == 2 {
                    trySwap()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeOrb?.removeFromParent()
        activeOrb = nil
        initialOrb?.alpha = 1
        initialOrb = nil
        isSwiping = false
        if swipedOrbs.count == 1 {
            if let handler = resolveMatchesHandler {
                handler()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    func trySwap() {

        if  let toOrb = level.orb(atColumn: swipedOrbs[1].column, row: swipedOrbs[1].row),
            let fromOrb = level.orb(atColumn: swipedOrbs[0].column, row: swipedOrbs[0].row) {
            
            if let handler = swipeHandler {
                let swap = Swap(orbA: fromOrb, orbB: toOrb)
                handler(swap)
            }
        }
    }
    
    
    //Mark: ANIMATIONS
    
    func animate(_ swap: Swap, completion: @escaping () -> Void) {
        let spriteA = swap.orbA.sprite!
        let spriteB = swap.orbB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let duration: TimeInterval = 0.01
        
        let moveA = SKAction.move(to: spriteB.position, duration: duration)
        moveA.timingMode = .easeOut
        spriteA.run(moveA, completion: completion)
        
        let moveB = SKAction.move(to: spriteA.position, duration: duration)
        moveB.timingMode = .easeOut
        spriteB.run(moveB)
        
        run(gameSound.orbMovementSound)
        
    }
    
    func animateMatchedOrbs(for chains: Set<Chain>, completion: @escaping () -> ()) {
        let sorted = (Array(chains)).sorted()
        
        let duration: TimeInterval = 0.3
        
        for (index, chain) in sorted.enumerated() {
            
            let waitForSoundAction = SKAction.wait(forDuration: duration * Double(index))
            comboCount += 1
            comboChains.append(contentsOf: chains)
            let soundAction = chain.orbs.count == 4 ? gameSound.TPASound : gameSound.comboSound(for: comboCount)
            run(SKAction.sequence([waitForSoundAction, soundAction]))
            
            for orb in chain.orbs {
                if let sprite = orb.sprite {
                    if sprite.action(forKey: "removing") == nil {
                        //Shrink orbs in chain
                        let scaleAction = SKAction.scale(to: 0.1, duration: duration)
                        scaleAction.timingMode = .easeOut
                        //Wait according to combo sequence before starting animation
                        let waitAction = SKAction.wait(forDuration: duration * Double(index))
                        sprite.run(SKAction.sequence([waitAction, scaleAction, SKAction.removeFromParent()]), withKey: "removing")
                    }
                }
            }
        }
        run(SKAction.wait(forDuration: duration * Double(sorted.count)), completion: completion)
    }
    
    func animateFallingOrbs(in columns: [[Orb]], completion: @escaping () -> ()) {
        var longestDuration: TimeInterval = 0
        let delay = TimeInterval(0.5)
        for array in columns {
            for (_, orb) in array.enumerated() {
                let newPosition = pointFor(column: orb.column, row: orb.row)
                
                let sprite = orb.sprite!
                let duration = TimeInterval(((sprite.position.y - newPosition.y) / tileHeight) * 0.1)
                longestDuration = duration
                
                let moveAction = SKAction.move(to: newPosition, duration: duration)
                moveAction.timingMode = .easeOut
                sprite.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: delay),
                        SKAction.group([moveAction])]))
            }
        }
        run(SKAction.wait(forDuration: delay+longestDuration), completion: completion)
    }
    
    func animateNewOrbs(in columns: [[Orb]], completion: @escaping () -> Void) {
        // 1
        var longestDuration: TimeInterval = 0
        
        for array in columns {
            // 2
            let startRow = array[0].row + 1
            
            for (index, orb) in array.enumerated() {
                // 3
                let sprite = SKSpriteNode(imageNamed: orb.element.spriteName)
                sprite.size = CGSize(width: tileWidth, height: tileHeight)
                sprite.position = pointFor(column: orb.column, row: startRow)
                orbsLayer.addChild(sprite)
                orb.sprite = sprite
                // 4
                let delay = 0.1 + 0.2 * TimeInterval(array.count - index - 1)
                // 5
                let duration = TimeInterval(startRow - orb.row) * 0.1
                longestDuration = max(longestDuration, duration + delay)
                // 6
                let newPosition = pointFor(column: orb.column, row: orb.row)
                let moveAction = SKAction.move(to: newPosition, duration: duration)
                moveAction.timingMode = .easeOut
                sprite.alpha = 0
                sprite.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: delay),
                        SKAction.group([
                            SKAction.fadeIn(withDuration: 0.05),
                            moveAction,])
                        ]))
            }
        }
        // 7
        run(SKAction.wait(forDuration: longestDuration), completion: completion)
    }
    
    func resolveCombos() {
        encounter.resolveComboDamage(for: comboChains)
    }
    
    func endCurrentStage() {
        print("defeated enemy")
    }
    
}

extension BattleScene: BattleDelegate {
    
    func animateEnemyAttack(named attack: String, reducingHeroHealthTo health: Float, completion: @escaping () -> ()) {
        //Animate label with attack name
        attackLabel.text = attack
        attackLabel.animateFlash(times: 3, duration: 2) {
            self.animateHeroHealth(reducedTo: health, completion: {
                completion()
            })
        }
        
        //Animate enemy sprite
        
        //Animate hero health bar
    }
    
    func animateHeroAttack(reducingEnemyHealthTo health: Float, completion: @escaping () -> ()) {
        
        enemyHealthBar.animateTo(percentage: health) {
            completion()
        }
    }
    
    
    func animateHeroHealth(reducedTo health: Float, completion: @escaping () -> ()) {
        playerHealthBar.animateTo(percentage: health) {
            completion()
        }
    }
    
    func disableBattleScene() {
        self.isUserInteractionEnabled = false
    }
    
    func enableBattleScene() {
        self.isUserInteractionEnabled = true
        resetTurn()
    }
    
    func resetTurn() {
        comboChains.removeAll()
        comboCount = 0
    }
    
    func dismissBattleScene() {
        sceneDelegate?.removeBattleScene(on: self.view!)
    }
    
    
    
    
}
