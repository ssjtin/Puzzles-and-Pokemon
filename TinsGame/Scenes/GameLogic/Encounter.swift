//
//  Encounter.swift
//  TinsGame
//
//  Created by Hoang Luong on 24/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//
import UIKit

let charizardStat = Stat(strength: 5, health: 120, recovery: 18, element: .Fire, expYield: 55)
let charizardImages = CharacterImages(backImage: nil, frontImage: "charizard-front")
let charizardBase = Monster(name: "Charizard", images: charizardImages, baseStat: charizardStat)
let charizardCharacter = EnemyMonster(baseMonster: charizardBase, attacks: [attack1, attack2], level: 20)

let pikachuStat = Stat(strength: 24, health: 60, recovery: 18, element: .Light, expYield: 34)
let pikachuImages = CharacterImages(backImage: "pikachu-back", frontImage: nil)
let pikachuBase = Monster(name: "pikachu", images: pikachuImages, baseStat: pikachuStat)
let pikachuCharacter = HeroMonster(id: "lskdj", encounterDate: 2309820, baseMonster: pikachuBase)

import Foundation

protocol BattleDelegate: class {
    
    func animateEnemyAttack(named: String, reducingHeroHealthTo health: Float, completion: @escaping() -> ())
    func animateHeroAttack(reducingEnemyHealthTo health: Float, completion: @escaping() -> ())
    
    func disableBattleScene()
    func enableBattleScene()
    
    func dismissBattleScene()
}

class Encounter {
    
    var battleDelegate: BattleDelegate?
    
    let enemyMonsters: EnemyMonster
    let heroMonsters: [HeroMonster?]
    
    //Hero status
    var heroHealth: (current: Int, max: Int)
    
    //Enemy status
    var enemyHealth: (current: Int, max: Int)
    var enemyCountdown: [(current: Int, max: Int)] = [(3, 3)]
    
    init(enemyMonsters: EnemyMonster = charizardCharacter, heroMonsters: [HeroMonster?] = [pikachuCharacter, nil, nil]) {
        self.enemyMonsters = enemyMonsters
        self.heroMonsters = heroMonsters
        
        let maxEnemyHealth = enemyMonsters.finalStat.health
        enemyHealth = (maxEnemyHealth, maxEnemyHealth)
        
        let maxHeroHealth = heroMonsters.compactMap { $0?.finalStat.health }.reduce(0) { $0 + $1 }
        heroHealth = (maxHeroHealth, maxHeroHealth)
    }

    //Decrease enemy health and return the remaining percentage health
    func reduceEnemyHealth(by points: Int) -> Float {
        
        let remainingHealth = enemyHealth.current - points
        enemyHealth.current = remainingHealth > 0 ? remainingHealth : 0
        
        return Float(enemyHealth.current)/Float(enemyHealth.max)
    }
    
    //Decrease hero health and return the remaining percentage health
    func reduceHeroHealth(by points: Int) -> Float {
        
        let remainingHealth = heroHealth.current - points
        heroHealth.current = remainingHealth > 0 ? remainingHealth : 0
        
        return Float(heroHealth.current)/Float(heroHealth.max)
    }
    
    private func calculateElementMultipliers(for chains: [Chain]) -> [(Element, Float)] {
        var attackMultipliers = [(Element, Float)]()
        
        let elements = Set(chains.map { $0.element })
        
        for element in elements {
            let elementChains = chains.filter{ $0.element == element }
            
            let TPAMultiplier = 1 + 0.5 * Float(elementChains.filter { $0.chainType == .TPA }.count )
            let orbMultiplier = Float((elementChains.reduce(0) { $0 + $1.numExtraOrbs })) * 0.25 + 1
            let comboMultiplier = 1 + Float(chains.count - 1) * 0.1
            
            attackMultipliers.append((element, TPAMultiplier * orbMultiplier * comboMultiplier ))
        }
        
        return attackMultipliers
    }
    
    func resolveComboDamage(for chains: [Chain]) {
        
        battleDelegate?.disableBattleScene()        //Disable user interaction
        
        let multipliers = calculateElementMultipliers(for: chains)
        
        var totalHeroDamage: Float = 0.0
        
        for monster in heroMonsters {
            guard let monsterStat = monster?.baseMonster.baseStat else { break }
            if let multiplier = multipliers.first(where: { $0.0 == monsterStat.element }) {
                totalHeroDamage += multiplier.1 * Float(monsterStat.strength)
            }
        }
        
        let remainingEnemyLife = reduceEnemyHealth(by: Int(totalHeroDamage))
        
        battleDelegate?.animateHeroAttack(reducingEnemyHealthTo: remainingEnemyLife, completion: {
            if remainingEnemyLife == 0 {
                print("enemy ded")
                self.battleDelegate?.dismissBattleScene()
            } else {
               self.enemyAttack()
            }
            
        })
        
    }
    

    func enemyAttack() {
        
        let attack = enemyMonsters.randomAttack()
        let finalAttackValue = enemyMonsters.finalStat.strength * attack.power / 100
        let remainingLife = reduceHeroHealth(by: finalAttackValue)
        
        battleDelegate?.animateEnemyAttack(named: attack.name, reducingHeroHealthTo: remainingLife, completion: {
            if remainingLife == 0 {
                print("player died")
                self.battleDelegate?.dismissBattleScene()
            } else {
                self.battleDelegate?.enableBattleScene()
            }
            
        })
        
    }
    
    func handleBattleCompletion() {
        
    }
    
}
