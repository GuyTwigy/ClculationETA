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
    
    func positionChanged(addressesArr: [AddressDistance]) -> [AddressDistance] {
        var results: [AddressDistance] = []
        
        if let firstAddress = addressesArr.first {
            results.append(AddressDistance(address: firstAddress.address, distanceETA: "", arriveETA: "9:00", isStart: true, coordinate: firstAddress.coordinate))
        }
        
        for i in 0..<addressesArr.count - 1 {
            let addressOne = addressesArr[i]
            let addressTwo = addressesArr[i + 1]
            let eta = calculateETABetweenTwoAddresses(addressOneCoordinate: addressOne.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), addressaddressTwoCoordinateTwo: addressTwo.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
            let conversToTime = Utils.addSecondsToTime(nowTime: results.last?.arriveETA ?? "9:00", seconds: eta.secondsDistance ?? 0)
            let addressDistance = AddressDistance(address: addressTwo.address, distanceETA: "\(eta.secondsDistance ?? 0)", arriveETA: conversToTime, isStart: false, coordinate: eta.coord2)
            results.append(addressDistance)
        }
        
        return results
    }
    
    func calculateETABetweenTwoAddresses(addressOneCoordinate: CLLocationCoordinate2D, addressaddressTwoCoordinateTwo: CLLocationCoordinate2D) -> (secondsDistance: Int?, coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) {
            let coord1 = addressOneCoordinate
            let coord2 = addressaddressTwoCoordinateTwo
        let distance = networkManager.calculateAerialDistance(coord1: coord1, coord2: coord2)
            let eta = Int((distance) / 10.0)
            return (eta, coord1, coord2)
    }
}
