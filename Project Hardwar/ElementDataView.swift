//
//  ElementDataRowView.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/10/25.
//

import Foundation
import SwiftUI

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

struct ElementListingView: View {
    @StateObject private var dataSource = DataSource()
    @State private var elements: [ElementData]
    @State private var selectedElements: Set<ElementData> = []
    
    var body: some View {
        List {
            ForEach(elements) { element in
                NavigationLink(destination: ElementEditView(element: element)) {
                    ElementDataRow(element: element)
                }
            }
            .onDelete(perform: deleteElement)
        }
        .onAppear {
            elements = dataSource.getData()
        }
        .toolbar {
            EditButton()
        }
    }
    
    init(elements: [ElementData] = []) {
        self.elements = elements
    }
    
    func deleteElement(at offsets: IndexSet) {
        /*
        for index in offsets {
            let elementToDelete = elements[index]
            print("Deleting \(elementToDelete.name ?? "unnamed element")")
        }
         */
    }
}

#Preview {
    ElementListingView()
}
