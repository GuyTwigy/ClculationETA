//
//  AddressDistance.swift
//  ClculationETA
//
//  Created by Guy Twig on 01/07/2024.
//

import Foundation
import CoreLocation

struct AddressDistance {
    let address: String?
    let distanceETA: String?
    let arriveETA: String?
    let isStart: Bool?
    var coordinate: CLLocationCoordinate2D?
    var infoOpen: Bool = false
}
