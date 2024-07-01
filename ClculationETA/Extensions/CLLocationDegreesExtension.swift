//
//  CLLocationDegreesExtension.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import CoreLocation

extension CLLocationDegrees {
    var degreesToRadians: Double {
        return self * .pi / 180.0
    }
}
