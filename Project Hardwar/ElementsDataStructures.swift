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
    case ability = 0
    case motive = 1
    case armamentUpgrade = 2
    case flaw = 3
    case performance = 4
    
    var title: String {
        switch self {
        case .ability:
            return "Ability"
        case .motive:
            return "Motive"
        case .armamentUpgrade:
            return "Armament Upgrade"
        case .flaw:
            return "Flaw"
        case .performance:
            return "Performance"
        }
    }
    
    var id: Int { self.rawValue }
}

enum ElementType: Int, Codable, CaseIterable, Identifiable {
    case vehicle = 0
    case walker = 1
    case trooper = 2
    case aircraft = 3
    
    var title: String {
        switch self {
        case .vehicle:
            return "Vehicle"
        case .walker:
            return "Walker"
        case .trooper:
            return "Trooper"
        case .aircraft:
            return "Aircraft"
        }
    }
    
    var id: Int { self.rawValue }
}

struct WeaponsAbilityData: Codable, Hashable {
    var name: String?
    var weaponsAbilityType: WeaponsAbilityType?
    var value: Int?
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
        case id, name, imageUrl, elementType, elementClass, version, manufacturer, stats
    }
    
    var id: UUID
    var name: String
    var imageUrl: String
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
    
    init(id: UUID, name: String, imageUrl: String, elementType: ElementType, elementClass: Int, version: Double, manufacturer: String, stats: ElementStats) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
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
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(imageUrl, forKey: .imageUrl)
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

struct ElementConstructionData {
    var element: ElementData?
    var id: UUID
    var name: String
    var imageUrl: String?
    var elementType: ElementType {
        didSet {
            if self.elementType == .aircraft {
                minimumMobility = elementClass
                if self.mobility < self.elementClass {
                    self.mobility = self.elementClass
                }
            } else {
                minimumMobility = 0
            }
        }
    }
    var elementClass: Int {
        didSet {
            if self.elementType == .aircraft {
                minimumMobility = elementClass
                if self.mobility < self.elementClass {
                    self.mobility = self.elementClass
                }
            } else {
                minimumMobility = 0
            }
        }
    }
    var manufacturer: String
    var version: Double
    var damage: Int {
        return elementClass * 2
    }
    
    var armor: Int
    var mobility: Int
    var defense: Int
    var firePower: Int
    var weaponsAbilities: [WeaponsAbilityData] = []
    
    var constructionPointsTotal: Int {
        getConstructionPointsTotal()
    }
    var constructionPointsSpent: Int {
        calculateConstructionPointsSpent()
    }
    var isExperimental: Bool = false
    var minimumMobility: Int = 0
    
    init() {
        id = UUID()
        name = ""
        imageUrl = nil
        elementType = .vehicle
        elementClass = 1
        manufacturer = ""
        version = 1.0
        armor = 0
        mobility = 0
        firePower = 0
        defense = 0
        weaponsAbilities = []
    }
    
    init(_ from: ElementData) {
        element = from
        id = from.id
        name = from.name
        imageUrl = from.imageUrl
        elementType = from.elementType
        elementClass = from.elementClass
        manufacturer = from.manufacturer
        version = from.version
        armor = from.stats.armor
        mobility = from.stats.mobility
        firePower = from.stats.firePower
        defense = from.stats.defense
        weaponsAbilities = from.stats.weaponsAbilities
    }
    
    func calculateConstructionPointsSpent() -> Int {
        var used = mobility + firePower + armor + defense
        used += weaponsAbilities.reduce(0) {
            x, y in
            switch y.weaponsAbilityType {
            case .motive:
                x
            default:
                x + (y.value ?? 1)
            }
        }
        return used
    }
    
    private func getConstructionPointsTotal() -> Int {
        return (constructionPoints[elementType]?[elementClass] ?? 0) + (isExperimental ? 2 : 0)
    }
    
    @discardableResult func save() -> ElementData? {
        if element == nil {
            return ElementData(
                id: id,
                name: name,
                imageUrl: imageUrl ?? "",
                elementType: elementType,
                elementClass: elementClass,
                version: version,
                manufacturer: manufacturer,
                stats: ElementStats(
                    mobility: mobility,
                    firePower: firePower,
                    armor: armor,
                    defense: defense,
                    weaponsAbilities: weaponsAbilities
                )
            )
        } else {
            element?.name = name
            element?.imageUrl = imageUrl ?? ""
            element?.elementType = elementType
            element?.elementClass = elementClass
            element?.version = version + 0.01
            element?.manufacturer = manufacturer
            element?.stats.mobility = mobility
            element?.stats.firePower = firePower
            element?.stats.armor = armor
            element?.stats.defense = defense
            element?.stats.weaponsAbilities = weaponsAbilities
        }
        return nil
    }
    
}

struct NullGServerResponse: Codable {
    var currentPage: Int?
    var totalPages: Int?
    var itemsPerPage: Int?
    var totalItems: Int?
    var items: [ElementData]?
    var status: String?
    var message: String?
}
