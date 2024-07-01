//
//  AppConstants.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import Foundation

class AppConstants {
    
    enum EndPoints {
        case maps
        case api
        case geocode
        case json
        
        var description: String {
            switch self {
            case .maps:
                return "/maps"
            case .api:
                return "/api"
            case .geocode:
                return "/geocode"
            case .json:
                return "/json"
            }
        }
    }
}
