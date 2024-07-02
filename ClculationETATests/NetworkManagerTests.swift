//
//  NetworkManagerTests.swift
//  ClculationETATests
//
//  Created by Guy Twig on 02/07/2024.
//

import XCTest
import CoreLocation
@testable import ClculationETA

final class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager?
    var mockSession: MockURLSession?
    
    override func setUpWithError() throws {
        mockSession = MockURLSession()
        networkManager = NetworkManager()
        if let mockSession {
            networkManager?.setSession(session: mockSession)
        }
    }
    
    override func tearDownWithError() throws {
        networkManager = nil
        mockSession = nil
    }
    
    func testBadURL() async throws {
        // Given
        
        // When
        do {
            _ = try await networkManager?.getRequestData(components: nil, type: LocationResponse.self)
            XCTFail()
        } catch {
            // Then
            XCTAssertEqual(error as? URLError, URLError(.badURL))
        }
    }
    
    func test_NetworkManager_BadServerResponse() async throws {
        // Given
        mockSession?.response = URLResponse(url: URL(string: networkManager?.baseUrl ?? "")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        
        // When
        do {
            _ = try await networkManager?.getRequestData(components: URLComponents(string: "\(networkManager?.baseUrl ?? "")\(AppConstants.EndPoints.maps.description)\(AppConstants.EndPoints.api.description)\(AppConstants.EndPoints.geocode.description)\(AppConstants.EndPoints.json.description)"), type: LocationResponse.self)
            XCTFail()
        } catch {
            // Then
            XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
        }
    }
    
    func test_NetworkManager_Non200StatusCode() async throws {
        // Given
        mockSession?.response = HTTPURLResponse(url: URL(string: networkManager?.baseUrl ?? "")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        // When
        do {
            _ = try await networkManager?.getRequestData(components: URLComponents(string: "\(networkManager?.baseUrl ?? "")\(AppConstants.EndPoints.maps.description)\(AppConstants.EndPoints.api.description)\(AppConstants.EndPoints.geocode.description)\(AppConstants.EndPoints.json.description)"), type: LocationResponse.self)
            XCTFail()
        } catch {
            // Then
            XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
        }
    }
    
    func test_NetworkManager_DataTaskError() async throws {
        // Given
        mockSession?.error = URLError(.notConnectedToInternet)
        
        // When
        do {
            _ = try await networkManager?.getRequestData(components: URLComponents(string: "\(networkManager?.baseUrl ?? "")\(AppConstants.EndPoints.maps.description)\(AppConstants.EndPoints.api.description)\(AppConstants.EndPoints.geocode.description)\(AppConstants.EndPoints.json.description)"), type: LocationResponse.self)
            XCTFail()
        } catch {
            // Then
            XCTAssertEqual(error as? URLError, URLError(.notConnectedToInternet))
        }
    }
    
    func test_NetworkManager_GetRequestDataSuccess() async throws {
        // Given
        let location = LocationResponse(results: [LocationData(geometry: GeometryData(location: LatAndLng(lat: 32.084041, lng: 34.887762)))])
        let data = try JSONEncoder().encode(location)
        let response = HTTPURLResponse(url: URL(string: networkManager?.baseUrl ?? "")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockSession?.data = data
        mockSession?.response = response
        
        // When
        var components = URLComponents(string: "\(networkManager?.baseUrl ?? "")\(AppConstants.EndPoints.maps.description)\(AppConstants.EndPoints.api.description)\(AppConstants.EndPoints.geocode.description)\(AppConstants.EndPoints.json.description)")
        components?.queryItems = [
            URLQueryItem(name: "address", value: "PetahTikva"),
            URLQueryItem(name: "key", value: networkManager?.googleMapsApiKey)
        ]
        let result = try await networkManager?.getRequestData(components: components, type: LocationResponse.self)
        
        // Then
        XCTAssertEqual(result?.results?.first?.geometry?.location?.lat, location.results?.first?.geometry?.location?.lat)
        XCTAssertEqual(result?.results?.first?.geometry?.location?.lng, location.results?.first?.geometry?.location?.lng)
        XCTAssertNotNil(result)
    }
}
