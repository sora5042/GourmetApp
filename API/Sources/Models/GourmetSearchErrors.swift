//
//  GourmetSearchErrors.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/18.
//

import Foundation

public struct GourmetSearchErrors: Decodable {
    public var results: Results
}

extension GourmetSearchErrors {
    public struct Results: Decodable {
        public var api_version: String
        public var error: [Error]
    }

    public struct Error: Decodable {
        public var code: Code
        public var message: String
    }

    public enum Code: Int, Decodable {
        case serverError = 1000
        case authenticationError = 2000
        case parameterError = 3000
    }
}
