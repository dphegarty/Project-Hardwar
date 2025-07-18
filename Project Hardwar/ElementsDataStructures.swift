//
//  DataStructs.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/8/25.
//

import Foundation
import SwiftUI
import SwiftData

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

@Model
final class ElementData: Codable, Identifiable, Hashable {
    
    enum CodingKeys: CodingKey {
        case id, name, image, elementType, elementClass, version, manufacturer, stats
    }
    
    var id: UUID
    var name: String
    var image: String
    var elementType: ElementType
    var elementClass: Int
    var version: Double
    var manufacturer: String
    var damage: Int {
        get {
            return elementClass * 2
        }
    }
    var stats: ElementStats = ElementStats()
    
    init(id: UUID, name: String, image: String, elementType: ElementType, elementClass: Int, version: Double, manufacturer: String, stats: ElementStats) {
        self.id = id
        self.name = name
        self.image = image
        self.elementType = elementType
        self.elementClass = elementClass
        self.version = version
        self.stats = stats
        self.manufacturer = manufacturer
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try UUID(uuidString: container.decode(String.self, forKey: .id)) ?? UUID()
        self.stats = try container.decode(ElementStats.self, forKey: .stats)
        self.name = try container.decode(String.self, forKey: .name)
        self.elementClass = try container.decode(Int.self, forKey: .elementClass)
        self.elementType = try container.decode(ElementType.self, forKey: .elementType)
        self.version = try container.decode(Double.self, forKey: .version)
        self.manufacturer = try container.decode(String.self, forKey: .manufacturer)
        self.image = try container.decode(String.self, forKey: .image)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(image, forKey: .image)
        try container.encode(elementType, forKey: .elementType)
        try container.encode(elementClass, forKey: .elementClass)
        try container.encode(version, forKey: .version)
        try container.encode(manufacturer, forKey: .manufacturer)
        try container.encode(stats, forKey: .stats)
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
