//
//  NPC.swift
//  TinsGame
//
//  Created by Hoang Luong on 7/8/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//
import Foundation

struct Map: Decodable {
    let npc: [NPC]
    let items: [Item]
}

struct Item: Decodable {
    
    let name: String
    let row: Int
    let column: Int
    var taken: Bool
    let spriteName: String
    
    enum ItemKeys: String, CodingKey {
        case name = "name"
        case row = "row"
        case column = "column"
        case taken = "taken"
        case spriteName = "spriteName"
        
    }
    
    init(name: String, row: Int, column: Int, taken: Bool, spriteName: String) {
        self.name = name
        self.row = row
        self.column = column
        self.taken = taken
        self.spriteName = spriteName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ItemKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let row: Int = try container.decode(Int.self, forKey: .row)
        let column: Int = try container.decode(Int.self, forKey: .column)
        let taken: Bool = try container.decode(Bool.self, forKey: .taken)
        let spriteName: String = try container.decode(String.self, forKey: .spriteName)
        
        self.init(name: name, row: row, column: column, taken: taken, spriteName: spriteName)
    }
    
}

struct NPC: Decodable {
    
    let name: String
    let startingRow: Int
    let startingColumn: Int
    let speech: [String]
    let spriteName: String
    
    enum NPCKeys: String, CodingKey {
        case name = "name"
        case startingRow = "startingRow"
        case startingColumn = "startingColumn"
        case speech = "speech"
        case spriteName = "spriteName"
    }
    
    init(name: String, startingRow: Int, startingColumn: Int, speech: [String], spriteName: String) {
        self.name = name
        self.startingRow = startingRow
        self.startingColumn = startingColumn
        self.speech = speech
        self.spriteName = spriteName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NPCKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let startingRow: Int = try container.decode(Int.self, forKey: .startingRow)
        let startingColumn: Int = try container.decode(Int.self, forKey: .startingColumn)
        let speech: [String] = try container.decode([String].self, forKey: .speech)
        let spriteName: String = try container.decode(String.self, forKey: .spriteName)
        
        self.init(name: name, startingRow: startingRow, startingColumn: startingColumn, speech: speech, spriteName: spriteName)
    }
    
}

class GameData {
    
    var mapData: Map!
    
    init(mapName: String) {
        loadMapData(mapName: mapName)
    }
    
    func loadMapData(mapName: String) {
        
        if let url = Bundle.main.url(forResource: "Maps", withExtension: "plist") {
            if let data = try? Data(contentsOf: url) {
                let mapDictionary = try? PropertyListDecoder().decode([String: Map].self, from: data)
                let mapData = mapDictionary![mapName]!
                self.mapData = mapData
                print(mapData)
            }
        }
        
    }
    
}
