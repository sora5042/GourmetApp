//
//  APIEndpoint.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/02.
//

import Foundation

public protocol APIEndpoint {
    var apiClient: APIClient { get }
    var path: String { get }
}
