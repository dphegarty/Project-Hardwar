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
    //@State var element: ElementData
    @State private var constructionItem: ElementConstructionData
    
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
    }
    
    init(element: ElementData) {
        //self.element = element
        constructionItem = ElementConstructionData(element)
    }
    
    func deleteWeaponsAbilities(_ offset: Int) {
        
    }
}

#Preview {
    let example = ElementData(id: UUID(), name: "Example", imageUrl: "", elementType: .vehicle, elementClass: 1, version: 1.0, manufacturer: "", stats: ElementStats())
    ElementEditView(element: example)
}
