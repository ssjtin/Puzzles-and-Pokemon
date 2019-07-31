//
//  Chain.swift
//  TinsGame
//
//  Created by Hoang Luong on 23/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

class Chain: Comparable, Hashable, CustomStringConvertible {
    
    //TODO: fix forced unwrap sorting
    static func < (lhs: Chain, rhs: Chain) -> Bool {
        return lhs.orbs.sorted().first! < rhs.orbs.sorted().first!
    }
    
    var orbs: [Orb] = []
    
    enum ChainType {
        case TPA
        case Row
        case Normal
    }
    
    var chainType: ChainType {
        if orbs.count == 4 {
            return .TPA
        } else {
            return .Normal
        }
    }
    
    func add(orb: Orb) {
        orbs.append(orb)
    }
    
    var length: Int {
        return orbs.count
    }
    
    var numExtraOrbs: Int {
        return orbs.count - 3
    }
    
    var element: Element {
        if let first = orbs.first {
            return first.element
        }
        
        return .unknown
    }
    
    var description: String {
        return "type:\(chainType) orbs:\(orbs)"
    }
    
    func hash(into hasher: inout Hasher) {
        for orb in orbs {
            hasher.combine(orb)
        }
    }
    
    static func ==(lhs: Chain, rhs: Chain) -> Bool {
        return lhs.orbs == rhs.orbs
    }
}
