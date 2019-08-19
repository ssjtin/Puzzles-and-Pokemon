//
//  GameSound.swift
//  TinsGame
//
//  Created by Hoang Luong on 24/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import AVFoundation
import SpriteKit

class MapSound {
    
    let bumpSound = SKAction.playSoundFileNamed("Obstruction", waitForCompletion: false)
    
}

class GameSound {
    
    let orbMovementSound = SKAction.playSoundFileNamed("OrbMovement", waitForCompletion: false)
    let TPASound = SKAction.playSoundFileNamed("TPASound", waitForCompletion: false)
    
    let comboSound1 = SKAction.playSoundFileNamed("ComboSound1", waitForCompletion: false)
    let comboSound2 = SKAction.playSoundFileNamed("ComboSound2", waitForCompletion: false)
    let comboSound3 = SKAction.playSoundFileNamed("ComboSound3", waitForCompletion: false)
    let comboSound4 = SKAction.playSoundFileNamed("ComboSound4", waitForCompletion: false)
    let comboSound5 = SKAction.playSoundFileNamed("ComboSound5", waitForCompletion: false)
    let comboSound6 = SKAction.playSoundFileNamed("ComboSound6", waitForCompletion: false)
    let comboSound7 = SKAction.playSoundFileNamed("ComboSound7", waitForCompletion: false)
    let comboSound8 = SKAction.playSoundFileNamed("ComboSound8", waitForCompletion: false)
    let comboSound9 = SKAction.playSoundFileNamed("ComboSound9", waitForCompletion: false)
    let comboSound10 = SKAction.playSoundFileNamed("ComboSound10", waitForCompletion: false)
    let comboSound11 = SKAction.playSoundFileNamed("ComboSound11", waitForCompletion: false)
    let comboSound12 = SKAction.playSoundFileNamed("ComboSound12", waitForCompletion: false)
    
    func comboSound(for comboNumber: Int) -> SKAction {
        switch comboNumber {
            
        case 1: return comboSound1
        case 2: return comboSound2
        case 3: return comboSound3
        case 4: return comboSound4
        case 5: return comboSound5
        case 6: return comboSound6
        case 7: return comboSound7
        case 8: return comboSound8
        case 9: return comboSound9
        case 10: return comboSound10
        case 11: return comboSound11
        case 12: return comboSound12
        
        default: return comboSound1
        }
    }
    
}
