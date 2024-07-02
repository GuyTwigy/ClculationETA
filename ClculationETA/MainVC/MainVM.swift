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
    private var networkManager = NetworkManager()
    
    func getDistance(addressesArr: [AddressDistance]) async throws {
        do {
            if !addressesArr.isEmpty {
                let coord = try await networkManager.getLocationSingleAdress(address: addressesArr.last?.address ?? "")
                var newArr = addressesArr
                var newElement = newArr.last
                newElement?.coordinate = coord
                newArr.removeLast()
                newArr.append(newElement ?? AddressDistance(address: nil, distanceETA: nil, arriveETA: nil, isStart: nil))
                newArr = positionChanged(addressesArr: newArr)
                delegate?.distanceBetweenAddresses(addressesDistance: newArr, error: nil)
            } else {
                delegate?.distanceBetweenAddresses(addressesDistance: [], error: nil)
            }
        } catch {
            delegate?.distanceBetweenAddresses(addressesDistance: nil, error: error)
        }
    }
    
    
    func positionChanged(addressesArr: [AddressDistance]) -> [AddressDistance] {
        var results: [AddressDistance] = []
        
        if let firstAddress = addressesArr.first {
            results.append(AddressDistance(address: firstAddress.address, distanceETA: "", arriveETA: "9:00", isStart: true, coordinate: firstAddress.coordinate))
        }
        
        if addressesArr.count > 1 {
            for i in 0..<addressesArr.count - 1 {
                let addressOne = addressesArr[i]
                let addressTwo = addressesArr[i + 1]
                let eta = calculateETABetweenTwoAddresses(addressOneCoordinate: addressOne.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), addressaddressTwoCoordinateTwo: addressTwo.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
                let conversToTime = Utils.addSecondsToTime(nowTime: results.last?.arriveETA ?? "9:00", seconds: eta.secondsDistance ?? 0)
                let addressDistance = AddressDistance(address: addressTwo.address, distanceETA: "\(eta.secondsDistance ?? 0)", arriveETA: conversToTime, isStart: false, coordinate: eta.coord2)
                results.append(addressDistance)
            }
        }
        
        return results
    }
    
    func calculateETABetweenTwoAddresses(addressOneCoordinate: CLLocationCoordinate2D, addressaddressTwoCoordinateTwo: CLLocationCoordinate2D) -> (secondsDistance: Int?, coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) {
        let coord1 = addressOneCoordinate
        let coord2 = addressaddressTwoCoordinateTwo
        let distance = calculateAerialDistance(coord1: coord1, coord2: coord2)
        let eta = Int((distance) / 10.0)
        return (eta, coord1, coord2)
    }
    
    func calculateAerialDistance(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> Double {
        let earthRadius = 6371000.0
        
        let lat1 = coord1.latitude.degreesToRadians
        let lon1 = coord1.longitude.degreesToRadians
        let lat2 = coord2.latitude.degreesToRadians
        let lon2 = coord2.longitude.degreesToRadians
        
        let dLat = lat2 - lat1
        let dLon = lon2 - lon1
        
        let a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        let distance = earthRadius * c
        return distance
    }
}
