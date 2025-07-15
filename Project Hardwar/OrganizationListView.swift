//
//  OrganizationListView.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/15/25.
//

import SwiftUI
import SwiftData

struct OrganizationEditView: View {
    @Environment(\.modelContext) var context
    @State var organization: OrganizationItem
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                TextField("Name", text: $organization.name)
            }
        }
    }
}

struct OrganizationItemDetailsView: View {
    @Environment(\.modelContext) var context
    @State var organization: OrganizationItem
    @State private var items: [ElementData] = []
    @State private var showAddElementView: Bool = false
    @State private var editOrganization: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Section("Details") {
                Text("\(organization.name)").frame(alignment: .leading)
            }
            Spacer()
            VStack {
                HStack {
                    Text("Children")
                        .frame(alignment: .leading)
                    Button("", systemImage: "plus") {
                        showAddElementView.toggle()
                        print(showAddElementView)
                    }
                    .sheet(isPresented: $showAddElementView) {
                        ElementListingView()
                    }
                }
                List {
                    ForEach(items) { child in
                        Text("\(child.name)").frame(alignment: .center)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            if let children = self.getChildren(organization.id) {
                items = children
            }
        }
        /*
        .onTapGesture {
            editOrganization.toggle()
        }
        .sheet(isPresented: $editOrganization, content: {
            OrganizationEditView(organization: organization)
        })
         */
    }
    
    func addElement() {
        
    }
    
    func getChildren(_ id: UUID) -> [ElementData]? {
        do {
            let predicate = #Predicate<ParentChildItem> { object in
                object.parentId == id
            }
            let desciptor = FetchDescriptor(predicate: predicate)
            let children = try context.fetch(desciptor)
            var elements: [ElementData] = []
            for child in children {
                let id = child.childId
                elements.append(contentsOf: try context.fetch(FetchDescriptor(predicate: #Predicate<ElementData> { object in
                    object.id == id
                })))
            }
            return elements
        } catch {
            return nil
        }
    }
}

struct OrganizationListView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \OrganizationItem.name) private var organizations: [OrganizationItem]
    
    var body: some View {
        List {
            ForEach(organizations) { organization in
                OrganizationItemDetailsView(organization: organization)
                /*
                NavigationLink(destination: OrganizationEditView(organization: organization)) {
                    OrganizationItemDetailsView(organization: organization)
                }
                 */
            }
        }
        .toolbar {
            Button("Add Organization", systemImage: "plus", action: addOrganization)
        }
    }
    
    func addOrganization() {
        let newOrganization = OrganizationItem(id: UUID(), name: "New Organization", factionId: nil, organizationType: .normal)
        context.insert(newOrganization)
    }
}
