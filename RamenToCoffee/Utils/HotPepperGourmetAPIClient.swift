//
//  HotPepperGourmetAPIClient.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/02.
//

import API
import Foundation

struct HotPepperGourmetAPIClient: APIClient {
    init(
        session: URLSessionProtocol = URLSession.shared
    ) {
        self.session = session
    }

    var baseURL: String {
        "https://webservice.recruit.co.jp/hotpepper/"
    }

    let session: URLSessionProtocol
    private let decoder = JSONDecoder()
    private var apiKey: APIKey = .init()

    func data(path: String? = nil, parameters: Parameters? = nil) async throws -> Data {
        var dictionary = try (parameters?.convertToDictionary() ?? [:]) + (apiKey.convertToDictionary())

        dictionary["format"] = "json"
        var request = urlRequest(path: path, parameters: dictionary)
        logger.debug([
            "URL: \(baseURL) \(path ?? "")",
            "Params: \(String(describing: parameters))"
        ].joined(separator: "\n"))
        return try await data(request)
    }

    func response<Response: Decodable>(path: String?, parameters: Parameters?) async throws -> Response {
        do {
            let data = try await data(path: path, parameters: parameters)
            return try decode(data)
        } catch {
            throw error
        }
    }

    private func decode<Response: Decodable>(_ data: Data) throws -> Response {
        do {
            let decoded = try decoder.decode(Response.self, from: data)
            return decoded
        } catch {
            logger.debug([
                "Response: \(String(describing: String(data: data, encoding: .utf8)))",
                "Error: \(error)"
            ].joined(separator: "\n"))
            throw APIError.message(error.localizedDescription)
        }
    }
}

private struct APIKey: Encodable {
    private let key: String = "a029724abd77ddd5"
}

extension APIClient where Self == HotPepperGourmetAPIClient {
    static var `default`: APIClient {
        HotPepperGourmetAPIClient()
    }
}

