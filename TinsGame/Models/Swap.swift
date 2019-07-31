//
//  Swap.swift
//  TinsGame
//
//  Created by Hoang Luong on 22/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

struct Swap: CustomStringConvertible {
    let orbA: Orb
    let orbB: Orb
    
    init(orbA: Orb, orbB: Orb) {
        self.orbA = orbA
        self.orbB = orbB
    }
    
    var description: String {
        return "swap \(orbA) with \(orbB)"
    }
}
