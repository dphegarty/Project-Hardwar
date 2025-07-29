//
//  ContentView.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/8/25.
//
import Foundation
import SwiftUI

struct ContentView: View {
    var items = [
        "Search Elements",
        "Manage Custom Elements",
        "Manage Organizations",
        "Manage Army Lists"
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items, id: \.self) { item in
                    NavigationLink(item, destination: {
                        switch item {
                        case "Search Elements":
                            ElementListingView()
                        case "Manage Custom Elements":
                            CustomElementListingView()
                        case "Manage Organizations":
                            OrganizationListView()
                        case "Manage Army Lists":
                            ArmyListMainView()
                        default:
                            ElementListingView()
                        }
                    })
                }
            }
        }
    }

}

#Preview {
    ContentView()
}
