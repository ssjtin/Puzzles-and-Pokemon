//
//  Enemy.swift
//  TinsGame
//
//  Created by Hoang Luong on 24/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

struct Monster {
    let name: String
    let images: CharacterImages
    let baseStat: Stat
}

struct Attack {
    let name: String
    let power: Int
    let effects: [(effect: Effect, duration: Int)]  //Tuples of effects, duration = how many turns the effect lasts
    let weight: Int     //Likelihood of attack, 1 is base value, example: attack with weight = 3 is 3 times more likely than attack with weight = 1
}

let attack1 = Attack(name: "Burn for a thousand years!!!", power: 120, effects: [], weight: 1)
let attack2 = Attack(name: "Dragon's scary face", power: 0, effects: [(.Weaken, 3)], weight: 1)


enum Effect {
    case SandAttack // Hero accuracy reduced by 30%
    case Poison     // Hero life reduced by 20% after each hero turn
    case BuffOut    // All positive effects removed
    case Weaken     // Hero strength reduced by 30%
}

struct EnemyMonster {
    let baseMonster: Monster
    let attacks: [Attack]
    let level: Int
    
    var finalStat: Stat {
        return calculateFinalStat()
    }
    
    init(baseMonster: Monster, attacks: [Attack] = [], level: Int = 5) {
        self.baseMonster = baseMonster
        self.attacks = attacks
        self.level = level
    }
    
    func randomAttack() -> Attack {
        let totalWeight = UInt32(attacks.map { $0.weight } .reduce(0,+))
        let rand = Int(arc4random_uniform(totalWeight))
        var sum = 0
        
        for attack in attacks {
            sum += attack.weight
            if rand < sum {
                return attack
            }
        }
        
        return Attack(name: "Struggle", power: 20, effects: [], weight: 1)
    }
    
    private func calculateFinalStat() -> Stat {
        let finalStrength = baseMonster.baseStat.strength * level / 100 + 5
        let finalHealth = baseMonster.baseStat.health * level / 100 + 10 + level
        let finalRecovery = baseMonster.baseStat.recovery * level / 100 + 5
        let experienceYield = baseMonster.baseStat.expYield * level / 7
        
        return Stat(
            strength: finalStrength,
            health: finalHealth,
            recovery: finalRecovery,
            element: baseMonster.baseStat.element,
            expYield: experienceYield
        )
    }
}

class HeroMonster {
    
    let id: String
    let encounterDate: TimeInterval
    let baseMonster: Monster
    
    var level: Int = 5
    var currentExp: Int = 0
    var expToNextLevel: Int = 0
    
    var finalStat: Stat {
        return calculateFinalStat()
    }
    
    init(id: String, encounterDate: TimeInterval, baseMonster: Monster) {
        self.id = id
        self.encounterDate = encounterDate
        self.baseMonster = baseMonster
    }
    
    private func calculateFinalStat() -> Stat {
        let finalStrength = baseMonster.baseStat.strength * level / 100 + 5
        let finalHealth = baseMonster.baseStat.health * level / 100 + 10 + level
        let finalRecovery = baseMonster.baseStat.recovery * level / 100 + 5
        let experienceYield = baseMonster.baseStat.expYield * level / 7
        
        return Stat(
            strength: finalStrength,
            health: finalHealth,
            recovery: finalRecovery,
            element: baseMonster.baseStat.element,
            expYield: experienceYield
        )
    }
    
}

struct CharacterImages {
    let backImage: String?
    let frontImage: String?
}

struct Stat {
    let strength: Int
    let health: Int
    let recovery: Int
    let element: Element
    let expYield: Int
}
