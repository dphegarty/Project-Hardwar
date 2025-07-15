//
//  Project_HardwarApp.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/8/25.
//

import SwiftUI
import SwiftData

@main
struct Project_HardwarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [ElementData.self])
        }
    }
}
