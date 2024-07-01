//
//  URLSessionProtocol.swift
//  ClculationETA
//
//  Created by Guy Twig on 30/06/2024.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
}

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error {
            throw error
        }
        return (data ?? Data(), response ?? URLResponse())
    }
}
