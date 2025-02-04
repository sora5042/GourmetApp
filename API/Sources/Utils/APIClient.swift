//
//  APIClient.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/02.
//

import Foundation
import LetterCase

public protocol APIClient {
    var baseURL: String { get }
    var session: URLSessionProtocol { get }
    func response<Response: Decodable>(path: String?, parameters: Parameters?) async throws -> Response
}

public typealias Parameters = any Encodable

extension APIClient {
    public func urlRequest(path: String? = nil, parameters: [String: Any]? = nil) -> URLRequest {
        let query = URLQueryBuilder(dictionary: parameters ?? [:]).build(with: [.urlEncoding])

        var url = URL(string: baseURL)!
        if let path {
            url = url.appendingPathComponent(path)
        }
            url = URL(string: url.absoluteString + "?" + query)!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return request
    }

    public func data(path: String? = nil, parameters: Parameters? = nil) async throws -> Data {
        let dictionary = try parameters?.convertToDictionary() ?? [:]
        let request = urlRequest(path: path, parameters: dictionary)
        return try await data(request)
    }

    public func data(_ request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    return data
                default:
                    throw APIError.data(data, httpResponse.statusCode)
                }
            } else {
                throw APIError.invalidResponse
            }
        } catch {
            switch error {
            case URLError.cancelled:
                throw APIError.cancelled
            default:
                throw error as? APIError ?? APIError.unknown(error)
            }
        }
    }
}

extension Dictionary {
    public static func + (lhs: Self, rhs: Self) -> Self {
        var new = lhs
        for element in rhs {
            new[element.key] = element.value
        }
        return new
    }
}
