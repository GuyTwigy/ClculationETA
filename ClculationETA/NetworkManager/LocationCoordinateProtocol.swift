//
//  LocationCoordinateProtocol.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import Foundation
import CoreLocation

protocol LocationCoordinateProtocol {
    func calculateETABetweenAdressesArray(addressesArr: [AddressDistance]) async throws -> [AddressDistance]
    func calculateETABetweenTwoAddresses(addressOne: String, addressTwo: String) async throws -> (secondsDistance: Int?, coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D)
    func getLocationSingleAdress(address: String) async throws -> CLLocationCoordinate2D
    func calculateAerialDistance(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> Double
}

extension NetworkManager: LocationCoordinateProtocol  {
    func calculateETABetweenAdressesArray(addressesArr: [AddressDistance]) async throws -> [AddressDistance] {
        var results: [AddressDistance] = []
        
        if let firstAddress = addressesArr.first {
            do {
                let coord = try await getLocationSingleAdress(address: firstAddress.address ?? "")
                results.append(AddressDistance(address: firstAddress.address, distanceETA: "", arriveETA: "9:00", isStart: true, coordinate: coord))
            } catch {
                throw error
            }
        }
        
        for i in 0..<addressesArr.count - 1 {
            let addressOne = addressesArr[i]
            let addressTwo = addressesArr[i + 1]
            
            do {
                let eta = try await self.calculateETABetweenTwoAddresses(addressOne: addressOne.address ?? "", addressTwo: addressTwo.address ?? "")
                let conversToTime = Utils.addSecondsToTime(nowTime: results.last?.arriveETA ?? "9:00", seconds: eta.secondsDistance ?? 0)
                let addressDistance = AddressDistance(address: addressTwo.address, distanceETA: "\(eta.secondsDistance ?? 0)", arriveETA: conversToTime, isStart: false, coordinate: eta.coord2)
                results.append(addressDistance)
            } catch {
                throw error
            }
        }
        
        return results
    }
    
    func calculateETABetweenTwoAddresses(addressOne: String, addressTwo: String) async throws -> (secondsDistance: Int?, coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) {
        do {
            let coord1 = try await self.getLocationSingleAdress(address: addressOne)
            let coord2 = try await self.getLocationSingleAdress(address: addressTwo)
            let distance = self.calculateAerialDistance(coord1: coord1, coord2: coord2)
            let eta = Int((distance) / 10.0)
            return (eta, coord1, coord2)
        } catch {
            throw error
        }
    }
    
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
