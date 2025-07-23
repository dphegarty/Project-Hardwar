//
//  Project_Hardwar_FileData.swift
//  Project Hardwar
//
//  Created by Dan Hegarty on 7/8/25.
//

import Foundation

class DataSource: ObservableObject {
    @Published var elements: [ElementData] = []
    var scheme = "https"
    var host = "api.nullg.tech"
    var apikey = "387e7e73-afae-4bd6-b6f2-a658c17d5d03"
    
    private func getURL(path: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        print("URL: \(urlComponents.url?.absoluteString ?? "N/A")")
        return urlComponents.url
    }
    
    func getURLRequest(method: String, path: String) -> URLRequest? {
        var request: URLRequest?
        if let url = getURL(path: path) {
            request = URLRequest(url: url)
            request?.httpMethod = method
            request?.setValue(apikey, forHTTPHeaderField: "X-API-Key")
            request?.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
            if method.uppercased() == "POST" {
                request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        return request
    }
    
    func getData() -> [ElementData] {
        print("Starting elements: \(elements.count)")
        guard let e = handleServerResponse() else {
            return []
        }
        print("Returning elements: \(e.count)")
        return e
    }
    
    private func getNetworData() -> [ElementData]? {
        return nil
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
