//
//  MainVM.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import Foundation
import CoreLocation

protocol MainVMDelegate: AnyObject {
    func distanceBetweenAddresses(addressesDistance: [AddressDistance]?, error: Error?)
}

class MainVM {
    
    weak var delegate: MainVMDelegate?
    var networkManager = NetworkManager()
    
    func getDistance(addressesArr: [AddressDistance]) async throws {
        do {
            let distance = try await networkManager.calculateETABetweenAdressesArray(addressesArr: addressesArr)
            delegate?.distanceBetweenAddresses(addressesDistance: distance, error: nil)
        } catch {
            delegate?.distanceBetweenAddresses(addressesDistance: nil, error: error)
        }
    }
}
