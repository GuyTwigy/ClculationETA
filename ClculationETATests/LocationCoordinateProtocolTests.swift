//
//  LocationCoordinateProtocolTests.swift
//  ClculationETATests
//
//  Created by Guy Twig on 02/07/2024.
//

import XCTest
@testable import ClculationETA

final class LocationCoordinateProtocolTests: XCTestCase {

    var dataService: LocationCoordinateProtocol?
    
    override func setUpWithError() throws {
        dataService = NetworkManager()
    }

    override func tearDownWithError() throws {
        dataService = nil
    }

    func test_NetworkManager_getLocationSingleAdressSuccess() async throws {
        // Given
        let locationData = LocationResponse(results: [LocationData(geometry: GeometryData(location: LatAndLng(lat: 32.084041, lng: 34.887762)))])
        
        // When
        let expectation = self.expectation(description: "Fetch Single Suggestion with Success")
        do {
            let locationResponse = try await dataService?.getLocationSingleAdress(address: "PetahTikva")
            expectation.fulfill()
            
            //Then
            XCTAssertNotNil(locationResponse)
            XCTAssertEqual(locationResponse?.latitude, locationData.results?.first?.geometry?.location?.lat)
            XCTAssertEqual(locationResponse?.longitude, locationData.results?.first?.geometry?.location?.lng)
        } catch {
            XCTFail()
        }
        
        await fulfillment(of: [expectation], timeout: 5.0, enforceOrder: true)
    }
}
