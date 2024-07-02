//
//  MainVMTests.swift
//  ClculationETATests
//
//  Created by Guy Twig on 02/07/2024.
//

import XCTest
import CoreLocation
@testable import ClculationETA

final class MainVMTests: XCTestCase {
    
    var vm: MainVM?
    
    override func setUpWithError() throws {
        vm = MainVM()
    }
    
    override func tearDownWithError() throws {
        vm = nil
    }
    
    func test_NetworkManager_getDistanceSuccess() async throws {
        // Given
        let addressesArray = [AddressDistance(address: "Petah Tikva", distanceETA: nil, arriveETA: nil, isStart: true),
                              AddressDistance(address: "Tel Aviv", distanceETA: nil, arriveETA: nil, isStart: false),
                              AddressDistance(address: "Jerusalem", distanceETA: nil, arriveETA: nil, isStart: false),
                              AddressDistance(address: "Ramat Gan", distanceETA: nil, arriveETA: nil, isStart: false),
                              AddressDistance(address: "Eilat", distanceETA: nil, arriveETA: nil, isStart: false)]
        
        
        // When
        let expectation = self.expectation(description: "Fetch Single location with Success")
        do {
            try await vm?.getDistance(addressesArr: addressesArray)
            expectation.fulfill()
            
            //Then
            XCTAssertFalse(vm?.adresses.isEmpty ?? true)
            XCTAssertEqual(vm?.adresses[0].address, addressesArray[0].address)
            XCTAssertEqual(vm?.adresses[0].isStart, addressesArray[0].isStart)
            XCTAssertNotNil(vm?.adresses[1].distanceETA)
            XCTAssertNotNil(vm?.adresses[1].arriveETA)
            XCTAssertNotNil(vm?.adresses[2].distanceETA)
            XCTAssertNotNil(vm?.adresses[2].arriveETA)
            XCTAssertNotNil(vm?.adresses[3].distanceETA)
            XCTAssertNotNil(vm?.adresses[3].arriveETA)
        } catch {
            XCTFail()
        }
        
        await fulfillment(of: [expectation], timeout: 5.0, enforceOrder: true)
    }
    
    func test_NetworkManager_positionChangedSuccess() async throws {
        // Given
        let addressesArray = [AddressDistance(address: "Petah Tikva", distanceETA: nil, arriveETA: nil, isStart: true),
                              AddressDistance(address: "Tel Aviv", distanceETA: nil, arriveETA: nil, isStart: false),
                              AddressDistance(address: "Jerusalem", distanceETA: nil, arriveETA: nil, isStart: false),
                              AddressDistance(address: "Ramat Gan", distanceETA: nil, arriveETA: nil, isStart: false),
                              AddressDistance(address: "Eilat", distanceETA: nil, arriveETA: nil, isStart: false)]
        
        
        // When
        let addressArray = vm?.positionChanged(addressesArr: addressesArray)
        
        //Then
        XCTAssertFalse(addressArray?.isEmpty ?? true)
        XCTAssertEqual(addressArray?[0].address, addressesArray[0].address)
        XCTAssertEqual(addressArray?[0].isStart, addressesArray[0].isStart)
        XCTAssertNotNil(addressArray?[1].distanceETA)
        XCTAssertNotNil(addressArray?[1].arriveETA)
        XCTAssertNotNil(addressArray?[2].distanceETA)
        XCTAssertNotNil(addressArray?[2].arriveETA)
        XCTAssertNotNil(addressArray?[3].distanceETA)
        XCTAssertNotNil(addressArray?[3].arriveETA)
    }
    
    func test_NetworkManager_calculateETABetweenTwoAddressesSuccess() async throws {
        // Given
        let etaArrivedSecondes = 998
        let addressesArray = [AddressDistance(address: "Petah Tikva", distanceETA: nil, arriveETA: nil, isStart: true, coordinate: CLLocationCoordinate2D(latitude: 32.084041, longitude: 34.887762)),
                              AddressDistance(address: "Tel Aviv", distanceETA: nil, arriveETA: nil, isStart: false, coordinate: CLLocationCoordinate2D(latitude: 32.0852999, longitude: 34.78176759999999)),
                              AddressDistance(address: "Jerusalem", distanceETA: nil, arriveETA: nil, isStart: false),
                              AddressDistance(address: "Ramat Gan", distanceETA: nil, arriveETA: nil, isStart: false),
                              AddressDistance(address: "Eilat", distanceETA: nil, arriveETA: nil, isStart: false)]
        
        
        // When
        let addressArray = vm?.positionChanged(addressesArr: addressesArray)
        let result = vm?.calculateETABetweenTwoAddresses(addressOneCoordinate: addressArray?[0].coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), addressaddressTwoCoordinateTwo: addressArray?[1].coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
        
        //Then
        XCTAssertFalse(addressArray?.isEmpty ?? true)
        XCTAssertEqual(addressArray?[0].address, addressesArray[0].address)
        XCTAssertEqual(addressArray?[0].isStart, addressesArray[0].isStart)
        XCTAssertNotNil(addressArray?[1].distanceETA)
        XCTAssertNotNil(addressArray?[1].arriveETA)
        XCTAssertNotNil(addressArray?[2].distanceETA)
        XCTAssertNotNil(addressArray?[2].arriveETA)
        XCTAssertNotNil(addressArray?[3].distanceETA)
        XCTAssertNotNil(addressArray?[3].arriveETA)
        
        XCTAssertNotNil(result?.secondsDistance)
        XCTAssertNotNil(result?.coord1)
        XCTAssertNotNil(result?.coord2)
        XCTAssertEqual(result?.secondsDistance, etaArrivedSecondes)
        XCTAssertEqual(result?.coord1.latitude, addressArray?[0].coordinate?.latitude)
        XCTAssertEqual(result?.coord1.longitude, addressArray?[0].coordinate?.longitude)
        XCTAssertEqual(result?.coord2.latitude, addressArray?[1].coordinate?.latitude)
        XCTAssertEqual(result?.coord2.longitude, addressArray?[1].coordinate?.longitude)
    }
    
    func test_NetworkManager_calculateAerialDistanceSuccess() async throws {
        // Given
        let distance = 9986.868492787005
        let addressesArray = [AddressDistance(address: "Petah Tikva", distanceETA: nil, arriveETA: nil, isStart: true, coordinate: CLLocationCoordinate2D(latitude: 32.084041, longitude: 34.887762)),
                              AddressDistance(address: "Tel Aviv", distanceETA: nil, arriveETA: nil, isStart: false, coordinate: CLLocationCoordinate2D(latitude: 32.0852999, longitude: 34.78176759999999)),
                              AddressDistance(address: "Jerusalem", distanceETA: nil, arriveETA: nil, isStart: false),
                              AddressDistance(address: "Ramat Gan", distanceETA: nil, arriveETA: nil, isStart: false),
                              AddressDistance(address: "Eilat", distanceETA: nil, arriveETA: nil, isStart: false)]
        
        
        // When
        let addressArray = vm?.positionChanged(addressesArr: addressesArray)
        let distanceResponse = vm?.calculateAerialDistance(coord1: addressArray?[0].coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), coord2: addressArray?[1].coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
        
        //Then
        XCTAssertFalse(addressArray?.isEmpty ?? true)
        XCTAssertEqual(addressArray?[0].address, addressesArray[0].address)
        XCTAssertEqual(addressArray?[0].isStart, addressesArray[0].isStart)
        XCTAssertNotNil(addressArray?[1].distanceETA)
        XCTAssertNotNil(addressArray?[1].arriveETA)
        XCTAssertNotNil(addressArray?[2].distanceETA)
        XCTAssertNotNil(addressArray?[2].arriveETA)
        XCTAssertNotNil(addressArray?[3].distanceETA)
        XCTAssertNotNil(addressArray?[3].arriveETA)
        
        XCTAssertNotNil(distanceResponse)
        XCTAssertEqual(distanceResponse, distance)
    }
}
