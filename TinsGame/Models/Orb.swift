//
//  Orb.swift
//  TinsGame
//
//  Created by Hoang Luong on 22/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit

enum Element: Int {
    case unknown = 0, Fire, Water, Grass, Light, Dark, Heal
    
    var spriteName: String {
        let spriteNames = [
            "RedOrb",
            "BlueOrb",
            "GreenOrb",
            "LightOrb",
            "DarkOrb",
            "HealOrb"]
        
        return spriteNames[rawValue - 1]
    }
    
    static func randomElement() -> Element {
        return Element(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
    
}

class Orb: CustomStringConvertible, Hashable, Comparable {
    
    static func < (lhs: Orb, rhs: Orb) -> Bool {
        return lhs.row < rhs.row ||
        (lhs.row == rhs.row && lhs.column < rhs.column)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(column)
        hasher.combine(row)
    }
    
    static func ==(lhs: Orb, rhs: Orb) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
    
    var description: String {
        return "type: \(element) square: (\(column), \(row))"
    }
    
    var column: Int
    var row: Int
    let element: Element
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, element: Element) {
        self.column = column
        self.row = row
        self.element = element
    }
    
}
