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
        let dictionary = try (parameters?.convertToDictionary() ?? [:]) + (apiKey.convertToDictionary())

        let request = urlRequest(path: path, parameters: dictionary)
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
            if let error = decoded as? GourmetSearchErrors {
                throw APIError.message(error.results.error.first?.message ?? "")
            } else {
                return decoded
            }
        } catch {
            if let errors = try? decoder.decode(GourmetSearchErrors.self, from: data) {
                if let error = errors.results.error.first {
                    switch error.code {
                    case .serverError:
                        throw HotPepperGourmetAPIError.serverError(code: error.code.rawValue, message: error.message)
                    case .authenticationError:
                        throw HotPepperGourmetAPIError.authenticationError(code: error.code.rawValue, message: error.message)
                    case .parameterError:
                        throw HotPepperGourmetAPIError.parameterError(code: error.code.rawValue, message: error.message)
                    }
                } else {
                    throw APIError.unknown(error)
                }
            } else {
                logger.debug([
                    "Response: \(String(describing: String(data: data, encoding: .utf8)))",
                    "Error: \(error)"
                ].joined(separator: "\n"))
                throw APIError.message(error.localizedDescription)
            }
        }
    }
}

enum HotPepperGourmetAPIError: Error {
    case serverError(code: Int, message: String)
    case authenticationError(code: Int, message: String)
    case parameterError(code: Int, message: String)

    var localizedDescription: String {
        switch self {
        case .serverError(let code, let message):
            return "サーバ障害エラー\nエラーコード\(code)\n\(message)"
        case .authenticationError(let code, let message):
            return "APIキーまたはIPアドレスの認証エラー\nエラーコード\(code)\n\(message)"
        case .parameterError(let code, let message):
            return "パラメータ不正エラー\nエラーコード:\(code)\n\(message)"
        }
    }
}

private struct APIKey: Encodable {
    private let key: String = "a029724abd77ddd5"
    private let format: String = "json"
}

extension APIClient where Self == HotPepperGourmetAPIClient {
    static var `default`: APIClient {
        HotPepperGourmetAPIClient()
    }
}

