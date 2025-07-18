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
    @Environment(\.modelContext) var context
    @State var armyListItem: ArmyListItem
    @Query(sort: \OrganizationItem.name) private var organizations: [OrganizationItem]
    @Query(sort: \FactionItem.name) private var factions: [FactionItem]
    @State private var children: [ParentChildItem] = []
    @State private var showAddElement: Bool = false
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Form {
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
                    Stepper("Class Points: \(armyListItem.pointsUsed)/\(armyListItem.pointsTotal)", value: $armyListItem.pointsTotal, in: 0...1000)
                }
            }
            .frame(height: 230)
            VStack {
                HStack(alignment: .center, spacing: 20) {
                    Text("Assigned Elements").frame(alignment: .leading).layoutPriority(1).bold()
                    Button("Add", action: {
                        showAddElement.toggle()
                        print("Toggled Show Add Element")
                    })
                    .sheet(isPresented: $showAddElement, onDismiss: {
                        loadChildren()
                    }) {
                        ElementSelectionListView(armyListItem: armyListItem)
                    }
                    EditButton()
                }.padding()
                List {
                    ForEach(children) { child in
                        ElementDataRowById(elementId: child.childId)
                    }
                    .onDelete(perform: deleteRows)
                }
            }
        }
        .onAppear {
            loadChildren()
        }
    }
    
    func loadChildren() {
        if let children = self.getChildren(self.armyListItem.id) {
            self.children = children
            armyListItem.pointsUsed = 0
            for child in children {
                if let elementClass = getElementClass(child.childId) {
                    armyListItem.pointsUsed += elementClass
                }
            }
        }
    }
    
    func deleteRows(at offsets: IndexSet) {
        offsets.forEach { index in
            let child = children.remove(at: index)
            if let elementClass = getElementClass(child.childId) {
                armyListItem.pointsUsed -= elementClass
            }
            context.delete(child)
        }
    }
    
    func getChildren(_ id: UUID) -> [ParentChildItem]? {
        do {
            let children = try context.fetch(FetchDescriptor(predicate: #Predicate<ParentChildItem> { object in
                object.parentId == id
            }))
            return children
        } catch {
            return nil
        }
    }
    
    func getElementClass(_ id: UUID) -> Int? {
        do {
            let element = try context.fetch(FetchDescriptor(predicate: #Predicate<ElementData> { object in
                object.id == id
            })).first
            return element?.elementClass
        } catch {
            return nil
        }
    }
}
