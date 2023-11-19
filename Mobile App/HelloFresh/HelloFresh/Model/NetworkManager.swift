//
//  NetworkManager.swift
//  HelloFresh
//
//  Created by Murad Talibov on 19.11.23.
//

import SwiftUI
import Alamofire

class NetworkManager {
    struct Constants {
        static let baseURL = "https://us-central1-ratatouille-ae161.cloudfunctions.net"
    }
    
    enum HTTPMethod: String {
        case post = "POST"
        case put = "PUT"
        case get = "GET"
        case delete = "DELETE"
    }
    
    var baseUrl: String {
        return Bundle.main.infoDictionary!["ServerURL"] as! String
    }

    private static func getUrl(endpoint: String?) -> String {
        if let endpoint = endpoint {
            return "\(Constants.baseURL)//\(endpoint)"
        } else {
            return Constants.baseURL
        }
    }
    
    static func makeGetRequest<T: Decodable>(endpoint: String?) async throws -> T {
        let url = getUrl(endpoint: endpoint)
        let request = AF.request(url)

        let data = try await request.serializingData().value
        
//        if let jsonString = String(data: data, encoding: .utf8) {
//            print(jsonString)
//        }
        
        let recipes = try JSONDecoder().decode(T.self, from: data)
        return recipes
    }
    
    static func makeGetRequest(endpoint: String?) async throws -> String {
        let url = getUrl(endpoint: endpoint)
        let request = AF.request(url)

        let data = try await request.serializingData().value
        
        guard let jsonString = String(data: data, encoding: .utf8) else { return "" }
        return jsonString
    }
    
    static func makePostRequest<T: Encodable>(endpoint: String?, body: T) async throws -> Data? {
        let url = self.getUrl(endpoint: endpoint)
        let request = AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default)

        let data = try await request.serializingData().value
        return data
    }
}
