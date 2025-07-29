//
//  ElementEditView.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/10/25.
//

import SwiftUI

struct AbilityRow: View {
    var ability: WeaponsAbilityData
    var body: some View {
        HStack {
            Text("\(ability.name ?? "No Name")")
            Spacer()
            Text("\(ability.weaponsAbilityType?.title ?? "No Type")")
        }
    }
}

struct ElementEditView: View {
    @State private var constructionItem: ElementConstructionData
    @State private var newAbility: WeaponsAbilityData = weaponAbilityOptions[0]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            Form {
                Section("Info") {
                    TextField("Name", text: $constructionItem.name)
                    Picker("Type", selection: $constructionItem.elementType) {
                        ForEach(ElementType.allCases, id: \.self) { item in
                            Text("\(item)").tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                    Toggle("Experimental", isOn: $constructionItem.isExperimental)
                    Stepper("Class \(constructionItem.elementClass)", value: $constructionItem.elementClass, in: 1...8)
                }
                Section("Construction") {
                    VStack {
                        HStack {
                            Text("Total Construction Points:").bold()
                            Spacer()
                            Text("\(constructionItem.constructionPointsTotal)")
                        }
                        HStack {
                            Text("Used Construction Points:").bold()
                            Spacer()
                            Text("\(constructionItem.constructionPointsSpent)")
                        }
                    }
                    VStack {
                        Stepper("Mobility: \(constructionItem.mobility)", value: $constructionItem.mobility, in: $constructionItem.minimumMobility.wrappedValue...10)
                        Stepper("Firepower: \(constructionItem.firePower)", value: $constructionItem.firePower)
                        Stepper("Armor: \(constructionItem.armor)", value: $constructionItem.armor)
                        Stepper("Defense: \(constructionItem.defense)", value: $constructionItem.defense)
                    }
                }
                Section("Abilities") {
                    List {
                        HStack(spacing: 20) {
                            Picker("Add:", selection: $newAbility) {
                                ForEach(WeaponsAbilityType.allCases, id: \.rawValue) { section in
                                    Section("\(section.title)") {
                                        ForEach(weaponAbilityOptions.filter {$0.weaponsAbilityType == section}, id: \.name) { ability in
                                            Text("\(ability.name ?? "No Name") Cost: \(ability.value ?? 1)").font(.caption).tag(ability)
                                        }
                                    }
                                }
                            }
                            Spacer()
                            Button("", systemImage: "plus") {
                                constructionItem.weaponsAbilities.append(newAbility)
                            }
                            .buttonStyle(.plain)
                        }
                        ForEach(constructionItem.weaponsAbilities, id: \.name) { ability in
                            HStack {
                                AbilityRow(ability: ability)
                            }
                        }
                        .onDelete { indexSet in
                            constructionItem.weaponsAbilities.remove(atOffsets: indexSet)
                        }
                    }
                }
            }
        }
        .navigationTitle("Edit \(constructionItem.name)")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            save()
        }
    }
    
    init(element: ElementData) {
        constructionItem = ElementConstructionData(element)
    }
    
    func save() {
        if let element = constructionItem.save() {
            modelContext.insert(element)
        }
    }
}

#Preview {
    let example = ElementData(id: UUID(), name: "Example", imageUrl: "", elementType: .vehicle, elementClass: 1, version: 1.0, manufacturer: "", stats: ElementStats())
    ElementEditView(element: example)
}
