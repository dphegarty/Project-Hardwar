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
    @State var element: ElementData
    @State private var stats: ElementStats = ElementStats()
    
    var body: some View {
        Form {
            TextField("Name", text: $element.name)
            Picker("Type", selection: $element.elementType) {
                ForEach(ElementType.allCases, id: \.self) { item in
                    Text("\(item)").tag(item)
                }
            }
            .pickerStyle(.segmented)
            Stepper("Class \(element.elementClass)", value: $element.elementClass, in: 1...8)
            Section("Stats") {
                VStack {
                    Stepper("Mobility: \(stats.mobility)", value: $stats.mobility)
                    Stepper("Firepower: \(stats.firePower)", value: $stats.firePower)
                    Stepper("Armor: \(stats.armor)", value: $stats.armor)
                    Stepper("Defense: \(stats.defense)", value: $stats.defense)
                }
            }
            Section("Abilities") {
                List {
                    ForEach(stats.weaponsAbilities, id: \.name) { ability in
                        HStack {
                           AbilityRow(ability: ability)
                        }
                    }
                }
            }
        }
        .navigationTitle("Edit \(element.name)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            stats = element.stats
        }
        .onDisappear {
            element.stats = stats
        }
    }
}

#Preview {
    let example = ElementData(id: UUID(), name: "Example", image: "", elementType: .vehicle, elementClass: 1, version: 1.0, manufacturer: "", stats: ElementStats())
    ElementEditView(element: example)
}
