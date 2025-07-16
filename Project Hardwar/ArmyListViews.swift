//
//  Untitled.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/16/25.
//

import SwiftUI
import SwiftData

struct ArmyListMainView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \ArmyListItem.name) private var armyLists: [ArmyListItem]
    @State private var showDetails: Bool = false
    
    var body: some View {
        List {
            ForEach(armyLists) { armyList in
                ArmyListItemView(armyListItem: armyList)
                    .onTapGesture {
                        showDetails.toggle()
                    }
                    .sheet(isPresented: $showDetails) {
                        ArmytListItemDetails(armyListItem: armyList)
                    }
            }
        }
        .toolbar {
            Button("New Army List", systemImage: "plus", action: addArmyList)
        }
    }
    
    func addArmyList() {
        let newArmyList = ArmyListItem(id: UUID(), name: "New Army List", factionId: nil, organizationId: nil, pointsTotal: 0, pointsUsed: 0)
        context.insert(newArmyList)
    }
}

struct ArmyListItemView: View {
    var armyListItem: ArmyListItem
    
    var body: some View {
        Text(armyListItem.name)
    }
}

struct ArmytListItemDetails: View {
    @State var armyListItem: ArmyListItem
    @Query(sort: \OrganizationItem.name) private var organizations: [OrganizationItem]
    @Query(sort: \FactionItem.name) private var factions: [FactionItem]
    
    var body: some View {
        Form {
            VStack{
                Section("Details") {
                    TextField("Name:", text: $armyListItem.name)
                    Picker("Faction:", selection: $armyListItem.factionId) {
                        ForEach(factions) { faction in
                            Text(faction.name).tag(faction.id)
                        }
                    }
                    Picker("Organization:", selection: $armyListItem.organizationId) {
                        ForEach(organizations) { organization in
                            Text(organization.name).tag(organization.id)
                        }
                    }
                }
                Spacer()
                Section("Elements") {
                    Stepper("Class Points: \(armyListItem.pointsUsed)/\(armyListItem.pointsTotal)", value: $armyListItem.pointsTotal, in: 0...1000)
                }
            }
        }
    }
}
