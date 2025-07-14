//
//  ElementListView.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/11/25.
//

import SwiftUI

struct ElementSearchView: View {
    @State private var searchText: String = ""
    @State private var selectedAction: String? = nil
    
    var body: some View {
        ElementListingView()
            .navigationTitle(Text("Project Hardwar"))
            .navigationDestination(for: ElementData.self, destination: ElementEditView.init)
            .searchable(text: $searchText)
            .toolbar {
                Button("Add New Element", systemImage: "plus", action: addElement)
                Menu("Actions", systemImage: "folder") {
                    Picker("Actions", selection: $selectedAction) {
                        Text("New List")
                            .tag("New List")
                        Text("Run")
                            .tag("Run")
                        Text("Export")
                            .tag("Export")
                    }
                    .pickerStyle(.inline)
                }
            }
    }

    func addElement() {
        
    }
}

#Preview {
    ElementSearchView()
}
