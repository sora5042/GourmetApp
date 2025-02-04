//
//  APIError.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/02.
//

import Foundation

public enum APIError: Error {
    case data(Data, Int?)
    case decodeError(Data, Error)
    case message(String)
    case invalidResponse
    case cancelled
    case unknown(Error)
}
