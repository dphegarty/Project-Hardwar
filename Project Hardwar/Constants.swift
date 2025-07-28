//
//  Constants.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/28/25.
//

let constructionPoints: [ElementType:[Int]] = [
    .vehicle:[0, 11, 14, 17, 20, 22, 24, 26, 28],
    .walker:[0, 11, 14, 17, 20, 22, 24, 26, 28],
    .trooper:[0, 11, 14, 17, 0, 0, 0, 0, 0],
    .aircraft:[0, 11, 14, 17, 20, 22, 24, 26, 28],
]

let weaponAbilityOptions: [WeaponsAbilityData] = [
    .init(name: "Tracked", weaponsAbilityType: .motive, value: 0),
    .init(name: "Walker", weaponsAbilityType: .motive, value: 0),
    .init(name: "Indirect Fire", weaponsAbilityType: .armamentUpgrade, value: 1),
    .init(name: "Ion Cannon", weaponsAbilityType: .armamentUpgrade, value: 1),
    .init(name: "Railgun", weaponsAbilityType: .armamentUpgrade, value: 1),
    .init(name: "XMG", weaponsAbilityType: .armamentUpgrade, value: 1),
    .init(name: "Smart", weaponsAbilityType: .ability, value: 1),
    .init(name: "Rapid", weaponsAbilityType: .ability, value: 1),
    .init(name: "Smokescreen", weaponsAbilityType: .ability, value: 1),
    .init(name: "Alert", weaponsAbilityType: .performance, value: 1),
    .init(name: "Assisted Targeting", weaponsAbilityType: .performance, value: 1),
    .init(name: "Full Strike", weaponsAbilityType: .performance, value: 1),
    .init(name: "Gunnery Controller", weaponsAbilityType: .performance, value: 1),
    .init(name: "Grasping Manipulators", weaponsAbilityType: .performance, value: 1),
    .init(name: "Bracing Mass", weaponsAbilityType: .performance, value: 1),
    .init(name: "Self-Repair", weaponsAbilityType: .performance, value: 1),
]
