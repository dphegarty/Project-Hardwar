//
//  ElementDataRowView.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/10/25.
//

import Foundation
import SwiftUI
import SwiftData

struct WeaponsAbilityText: View {
    var weaponsAbility: WeaponsAbilityData?
    var separator: String = ", "
    
    var body: some View {
        if let a = weaponsAbility {
            switch a.weaponsAbilityType {
            case .normal:
                Text("\(a.name ?? "No Name")\(separator)").font(.custom("Arial", size: 11))
            case .motive:
                Text("\(a.name ?? "No Name")\(separator)").font(.custom("Arial", size: 11)).italic()
            case .armamentUpgrade:
                Text("\(a.name ?? "No Name")\(separator)").font(.custom("Arial", size: 11)).bold()
            default:
                Text("\(a.name ?? "No Name")\(separator)").font(.custom("Arial", size: 11))
            }
        } else {
            Text("No Name").font(.caption2)
        }
    }
}

struct ElementDataRow: View {
    var element: ElementData
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 20) {
                Text(element.name.uppercased()).font(.subheadline).frame(maxWidth: .infinity).bold()
                switch element.elementType {
                case .vehicle:
                    Text("Vehicle").font(.subheadline).frame(maxWidth: .infinity, alignment: .trailing)
                case .walker:
                    Text("Walker").font(.subheadline).frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            VStack {
                Text("C\(element.elementClass)").font(.subheadline).frame(maxWidth: .infinity, alignment: .trailing)
            }
            VStack(spacing: 3) {
                Text("M: \(element.stats.mobility)").font(.custom("Arial", size: 15)).frame(maxWidth: 35, alignment: .leading)
                Text("F: \(element.stats.firePower)").font(.custom("Arial", size: 15)).frame(maxWidth: 35, alignment: .leading)
                Text("A: \(element.stats.armor)").font(.custom("Arial", size: 15)).frame(maxWidth: 35, alignment: .leading)
                Text("D: \(element.stats.defense)").font(.custom("Arial", size: 15)).frame(maxWidth: 35, alignment: .leading)
            }.padding(.leading, 0)
            HStack(spacing: 1) {
                Text("Damage:").font(.custom("Arial", size: 15)).frame(maxWidth: 75, alignment: .leading).bold()
                ForEach(0..<element.damage, id: \.self) { i in
                    Image(systemName: "square").imageScale(.medium)
                }
            }.padding(.leading, 0)
            Text("Abilties").font(.custom("Arial", size: 15))
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 5) {
                ForEach(element.stats.weaponsAbilities, id: \.name) { ability in
                    WeaponsAbilityText(weaponsAbility: ability)
                }
            }
            .padding(.leading, 10)
        }
        .padding(8)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ElementDataRowById: View {
    @Environment(\.modelContext) private var context
    @State var elementId: UUID
    @State private var element = ElementData(id: UUID(), name: "Placeholder", image: "", elementType: .vehicle, elementClass: 0, version: 1.01, manufacturer: "", stats: ElementStats(firePower: 0, armor: 0, defense: 0, weaponsAbilities: []))
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 20) {
                Text(element.name.uppercased()).font(.subheadline).frame(maxWidth: .infinity).bold()
                switch element.elementType {
                case .vehicle:
                    Text("Vehicle").font(.subheadline).frame(maxWidth: .infinity, alignment: .trailing)
                case .walker:
                    Text("Walker").font(.subheadline).frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            VStack {
                Text("C\(element.elementClass)").font(.subheadline).frame(maxWidth: .infinity, alignment: .trailing)
            }
            VStack(spacing: 3) {
                Text("M: \(element.stats.mobility)").font(.custom("Arial", size: 15)).frame(maxWidth: 35, alignment: .leading)
                Text("F: \(element.stats.firePower)").font(.custom("Arial", size: 15)).frame(maxWidth: 35, alignment: .leading)
                Text("A: \(element.stats.armor)").font(.custom("Arial", size: 15)).frame(maxWidth: 35, alignment: .leading)
                Text("D: \(element.stats.defense)").font(.custom("Arial", size: 15)).frame(maxWidth: 35, alignment: .leading)
            }.padding(.leading, 0)
            HStack(spacing: 1) {
                Text("Damage:").font(.custom("Arial", size: 15)).frame(maxWidth: 75, alignment: .leading).bold()
                ForEach(0..<element.damage, id: \.self) { i in
                    Image(systemName: "square").imageScale(.medium)
                }
            }.padding(.leading, 0)
            Text("Abilties").font(.custom("Arial", size: 15))
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 5) {
                ForEach(element.stats.weaponsAbilities, id: \.name) { ability in
                    WeaponsAbilityText(weaponsAbility: ability)
                }
            }
            .padding(.leading, 10)
        }
        .padding(8)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onAppear {
            populateElementData()
        }
    }
    
    func populateElementData() {
        do {
            if let item = try context.fetch(FetchDescriptor(predicate: #Predicate<ElementData> { object in
                object.id == elementId
            })).first {
                element = item
            }
        } catch {
            element = ElementData(id: UUID(), name: "Error loading element data", image: "", elementType: .vehicle, elementClass: 0, version: 1.01, manufacturer: "", stats: ElementStats(firePower: 0, armor: 0, defense: 0, weaponsAbilities: []))
        }
    }
}

struct ElementSelectionListView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State private var editMode: EditMode = .active
    @StateObject private var dataSource = DataSource()
    @State private var elements: [ElementData] = []
    @State private var selection: Set<UUID> = []
    @State var armyListItem: ArmyListItem
    @State private var finishedSelection: Bool = false
    
    var body: some View {
        Button("Done") {
            finishedSelection.toggle()
            handleSelection()
        }
        List(elements, selection: $selection) { element in
            ElementDataRow(element: element).tag(element.id)
        }
        .onAppear {
            elements = dataSource.getData()
        }
        .environment(\.editMode, $editMode)
    }
    
    func handleSelection() {
        for elementId in selection {
            let parentChildItem = ParentChildItem(parentId: armyListItem.id, childId: elementId, parentChildType: .armyList)
            context.insert(parentChildItem)
            if !doesDetailsElementExist(elementId) {
                if let element = elements.first(where: { $0.id == elementId }) {
                    context.insert(element)
                }
            }
        }
        dismiss()
    }
    
    func doesDetailsElementExist(_ elementId: UUID) -> Bool {
        do {
            if try context.fetch(FetchDescriptor(predicate: #Predicate<ElementData> { object in
                object.id == elementId
            })).isEmpty {
                return false
            }
            return true
        } catch {
            return true
        }
    }
}

struct ElementListingView: View {
    @StateObject private var dataSource = DataSource()
    @State private var elements: [ElementData] = []
    @State private var searchText: String = ""
    private var filteredElements: [ElementData] {
        if searchText.isEmpty {
            return elements
        } else {
            return elements.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.manufacturer.lowercased().contains(searchText.lowercased()) ||
                $0.elementClass.description.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredElements) { element in
                NavigationLink(destination: ElementEditView(element: element)) {
                    ElementDataRow(element: element)
                }
            }
        }
        .onAppear {
            //elements = dataSource.getData()
            fetchData()
        }
        .searchable(text: $searchText)
    }
    
    func fetchData() {
        if let request = dataSource.getURLRequest(method: "post", path: "/v4/hardwar/elementData") {
            let filter: [String:AnyHashable] = [:]
            let project: [String:AnyHashable] = [:]
            let requestBody: [String: AnyHashable] = [
                "filter": filter,
                "itemsPerPage": 50,
                "page": 1,
                "project": project
            ]
            let uploadData = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
            URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
                guard let data = data else { return }
                guard let response = response as? HTTPURLResponse else { return }
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    do {
                        let serverResponse = try JSONDecoder().decode(NullGServerResponse.self, from: JSONSerialization.data(withJSONObject: json, options: []))
                        DispatchQueue.main.async {
                            self.elements = serverResponse.items ?? []
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
}

#Preview {
    ElementListingView()
}
