//
//  DataStructs.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/8/25.
//

import Foundation
import SwiftUI

enum WeaponsAbilityType: Int, Codable, CaseIterable, Identifiable {
    case normal = 0
    case motive = 1
    case armamentUpgrade = 2
    
    var id: Int { self.rawValue }
}

enum ElementType: Int, Codable, CaseIterable, Identifiable {
    case vehicle = 0
    case walker = 1
    
    var id: Int { self.rawValue }
}

struct WeaponsAbilityData: Codable, Hashable {
    var name: String?
    var weaponsAbilityType: WeaponsAbilityType?
}

struct ElementStats: Codable, Hashable {
    var mobility: Int = 0
    var firePower: Int = 0
    var armor: Int = 0
    var defense: Int = 0
    var weaponsAbilities: [WeaponsAbilityData] = []
    
    static func == (lhs: ElementStats, rhs: ElementStats) -> Bool {
        if lhs.mobility == rhs.mobility,
           lhs.firePower == rhs.firePower,
           lhs.armor == rhs.armor,
           lhs.defense == rhs.defense,
           lhs.weaponsAbilities == rhs.weaponsAbilities
        {
            return true
        }
        return false
    }
}

struct ElementData: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var image: String
    var elementType: ElementType
    var elementClass: Int
    var version: Double
    var damage: Int {
        get {
            return elementClass * 2
        }
    }
    var stats: ElementStats = ElementStats()
    
    init(id: String, name: String, image: String, elementType: ElementType, elementClass: Int, version: Double, stats: ElementStats) {
        self.id = id
        self.name = name
        self.image = image
        self.elementType = elementType
        self.elementClass = elementClass
        self.version = version
        self.stats = stats
    }
    
    static func == (lhs: ElementData, rhs: ElementData) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
}

struct NullGServerResponse: Codable {
    var items: [ElementData]?
    var count: Int?
    var page: Int?
    var totalPages: Int?
    var itemsPerPage: Int?
}
