//
//  LocationData.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import Foundation

class LocationResponse: Decodable {
    let results: [LocationData]?
}

class LocationData: Decodable {
    let geometry: GeometryData?
}

class GeometryData: Decodable {
    let location: LatAndLng?
}

class LatAndLng: Decodable {
    let lat: Double?
    let lng: Double?
}
