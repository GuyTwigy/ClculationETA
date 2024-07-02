//
//  LocationData.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import Foundation

class LocationResponse: Codable {
    let results: [LocationData]?
    
    init(results: [LocationData]?) {
        self.results = results
    }
}

class LocationData: Codable {
    let geometry: GeometryData?
    
    init(geometry: GeometryData?) {
        self.geometry = geometry
    }
}

class GeometryData: Codable {
    let location: LatAndLng?
    
    init(location: LatAndLng?) {
        self.location = location
    }
}

class LatAndLng: Codable {
    let lat: Double?
    let lng: Double?
    
    init(lat: Double?, lng: Double?) {
        self.lat = lat
        self.lng = lng
    }
}
