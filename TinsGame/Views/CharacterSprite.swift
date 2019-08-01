//
//  CharacterSprite.swift
//  TinsGame
//
//  Created by Hoang Luong on 31/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit

class CharacterSprite: SKSpriteNode {
    
    let textureAtlas: SKTextureAtlas!
    let textureName: String
    
    convenience init() {
        self.init(textureName: "character")
    }
    
    init(textureName: String) {
        self.textureName = textureName
        self.textureAtlas = SKTextureAtlas(named: textureName)
        
        super.init(texture: nil, color: .clear, size: CGSize(width: 50, height: 50))
        
        texture = SKTexture(imageNamed: textureName + "_walk_down_1")
        zPosition = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateMoving(to destination: CGPoint, in direction: Direction, completion: @escaping () -> ()) {
        
        guard direction != .None else { completion(); return }
        
        let walkFrames = getWalkFrames(for: direction)
        let moveAction = SKAction.move(to: destination, duration: stepDuration)
        let walkAnimation = SKAction.animate(with: walkFrames, timePerFrame: stepDuration/3, resize: false, restore: false)
        
        let group = SKAction.group([walkAnimation, moveAction])
        let completionBlock = SKAction.run {
            completion()
        }
        let sequence = SKAction.sequence([group, completionBlock])
        run(sequence, withKey: "moving" + textureName)
    }
    
    func animateShuffleFootsteps(in direction: Direction, completion: @escaping () -> ()) {
        
        guard direction != .None else { completion(); return }
        
        let walkFrames = getWalkFrames(for: direction)
        let walkAnimation = SKAction.animate(with: walkFrames, timePerFrame: stepDuration, resize: false, restore: false)
        let completionBlock = SKAction.run {
            completion()
        }
        let sequence = SKAction.sequence([walkAnimation, completionBlock])
        run(sequence, withKey: "moving")
    }
    
    func getWalkFrames(for direction: Direction) -> [SKTexture] {
        
        var spriteString = textureName
        var walkFrames = [SKTexture]()
        
        switch direction {
        case .Up:       spriteString += "_walk_up_"
        case .Down:     spriteString += "_walk_down_"
        case .Left:     spriteString += "_walk_left_"
        case .Right:    spriteString += "_walk_right_"
        default: ()
        }
        
        for i in 1...3 {
            walkFrames.append(textureAtlas.textureNamed(spriteString + String(i)))
        }
        
        return walkFrames
    }
}
