//
//  LocationCoordinateProtocol.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import Foundation
import CoreLocation

protocol LocationCoordinateProtocol {
    func getLocationSingleAdress(address: String) async throws -> CLLocationCoordinate2D
}

extension NetworkManager: LocationCoordinateProtocol  {
    func getLocationSingleAdress(address: String) async throws -> CLLocationCoordinate2D {
        var components = URLComponents(string: "\(baseUrl)\(AppConstants.EndPoints.maps.description)\(AppConstants.EndPoints.api.description)\(AppConstants.EndPoints.geocode.description)\(AppConstants.EndPoints.json.description)") ?? URLComponents()
        
        components.queryItems = [
            URLQueryItem(name: "address", value: "\(address.capitalized)"),
            URLQueryItem(name: "key", value: googleMapsApiKey)
        ]
        
        do {
            let location = try await getRequestData(components: components, type: LocationResponse.self)
            let locationCoordinate = CLLocationCoordinate2D(latitude: location.results?.first?.geometry?.location?.lat ?? 0, longitude: location.results?.first?.geometry?.location?.lng ?? 0)
            return locationCoordinate
        } catch {
            throw error
        }
    }
}
