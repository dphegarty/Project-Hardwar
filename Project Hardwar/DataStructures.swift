//
//  DataStructures.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/15/25.
//

import SwiftUI
import SwiftData

enum OrganizationType: String, CaseIterable, Codable {
    case normal
}

enum ParentChildType: String, CaseIterable, Codable {
    case organization
    case faction
    case armyList
}

@Model
final class OrganizationItem {
    var id: UUID
    var name: String
    var factionId: UUID?
    var organizationType: OrganizationType
    
    init(id: UUID, name: String, factionId: UUID?, organizationType: OrganizationType) {
        self.id = id
        self.name = name
        self.factionId = factionId
        self.organizationType = organizationType
    }
}

@Model
final class FactionItem {
    var id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

@Model
final class ArmyListItem {
    var id: UUID
    var name: String
    var factionId: UUID
    var organizationId: UUID
    var pointsTotal: Int = 0
    var pointsUsed: Int = 0
    var pointsAvailable: Int { pointsTotal - pointsUsed }
    
    init(id: UUID, name: String, factionId: UUID, organizationId: UUID, pointsTotal: Int = 0, pointsUsed: Int = 0) {
        self.id = id
        self.name = name
        self.factionId = factionId
        self.organizationId = organizationId
        self.pointsUsed = pointsUsed
        self.pointsTotal = pointsTotal
    }
}

@Model
final class InventoryItem {
    var id: UUID
    var elementId: UUID
    
    init(id: UUID, elementId: UUID) {
        self.id = id
        self.elementId = elementId
    }
}

@Model
final class ParentChildItem {
    var id: UUID
    var parentId: UUID
    var childId: UUID
    var parentChildType: ParentChildType
    
    init(id: UUID, parentId: UUID, childId: UUID, parentChildType: ParentChildType) {
        self.id = id
        self.parentId = parentId
        self.childId = childId
        self.parentChildType = parentChildType
    }
}
