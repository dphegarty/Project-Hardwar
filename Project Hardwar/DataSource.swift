//
//  Project_Hardwar_FileData.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/8/25.
//

import Foundation

class DataSource: ObservableObject {
    @Published var elements: [ElementData] = []
    
    func getData() -> [ElementData] {
        guard let e = handleServerResponse() else {
            return []
        }
        return e
    }
    
    private func handleServerResponse() -> [ElementData]? {
        if let url = Bundle.main.url(forResource: "ElementsJsonData", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    do {
                        let serverResponse = try JSONDecoder().decode(NullGServerResponse.self, from: JSONSerialization.data(withJSONObject: json, options: []))
                        print("Contract: Loaded Unit Data")
                        return serverResponse.items
                    } catch {
                        print("Contact: Failed to decode JSON data: \(error)")
                    }
                } else {
                    print("Contract: Failed to load JSON")
                }
            } else {
                print("Contract: Failed to load file")
            }
        } else {
            print("Contract: Failed to locate random tables file")
        }
        return nil
    }
}
