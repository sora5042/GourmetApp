//
//  CodableExtensions.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/02.
//

import Foundation

extension Encodable {
    public func convertToDictionary() throws -> [String: Any] {
        try JSONSerialization.jsonObject(with: JSONEncoder().encode(self), options: []) as! [String: Any]
    }
}
