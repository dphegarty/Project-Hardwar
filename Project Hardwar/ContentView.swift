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
        "Manage Organizations",
        "Manage Army Lists"
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items, id: \.self) { item in
                    NavigationLink(item, destination: {
                        if item == "Search Elements" {
                            ElementListingView()
                        } else if item == "Manage Organizations" {
                            OrganizationListView()
                        } else if item == "Manage Army Lists" {
                            ElementListingView()
                        }
                    }
                    )
                }
            }
        }
    }

}

#Preview {
    ContentView()
}
