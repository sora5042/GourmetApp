//
//  URLSessionsProtocol.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/02.
//

import Foundation

public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
