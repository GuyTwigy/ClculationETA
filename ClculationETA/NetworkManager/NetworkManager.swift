//
//  NetworkManager.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import Foundation

import Foundation

class NetworkManager {
    
    let baseUrl = "https://maps.googleapis.com"
    let googleMapsApiKey: String = "AIzaSyDupzENE0PN855I9sPXKyw8B0gbueYpUPM"
    
    private var session: URLSessionProtocol = URLSession.shared

    func setSession(session: URLSessionProtocol) {
        self.session = session
    }
    
    func getRequestData<T: Decodable>(components: URLComponents?, type: T.Type) async throws -> T {
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedData = try JSONDecoder().decode(type, from: data)
        return decodedData
    }
}
