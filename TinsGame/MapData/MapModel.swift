//
//  AreaModel.swift
//  TinsGame
//
//  Created by Hoang Luong on 30/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

struct Map: Codable {
    let name: String
    let encounterAreas: [EncounterArea]
    let trainers: [Trainer]
}

struct EncounterArea: Codable {
    let name: String
    let rate: Int
    let monsters: [String]
}

struct Trainer: Codable {
    let name: String
    let monsters: [TrainerMonster]
}

struct TrainerMonster: Codable {
    let name: String
    let level: Int
}
