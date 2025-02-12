//
//  URLQueryBuilder.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/02.
//

import Foundation

private protocol URLQueryRespresentable {}

extension Int: URLQueryRespresentable {}

extension Float: URLQueryRespresentable {}

extension Double: URLQueryRespresentable {}

extension Decimal: URLQueryRespresentable {}

extension String: URLQueryRespresentable {}

public class URLQueryBuilder {
    public enum Options {
        case urlEncoding
    }

    public private(set) var dictionary: [String: Any]

    public init(dictionary: [String: Any]) {
        self.dictionary = dictionary
    }

    public init(encodable: some Encodable) {
        dictionary = try! encodable.convertToDictionary()
    }

    private var options: [Options] = []
    public func build(with options: [Options] = []) -> String {
        self.options = options
        return queryString(with: dictionary)
    }

    private func queryString(with dictionary: [String: Any], parentKey: String? = nil) -> String {
        dictionary.compactMap { (key: String, value: Any) -> String? in
            let currentKey: String
            if let parentKey: String = parentKey {
                currentKey = "\(parentKey)[\(key)]"
            } else {
                currentKey = key
            }

            if let string = value as? String, !string.isEmpty {
                return "\(currentKey)=\(self.queryString(with: string))"
            } else if let int = value as? Int {
                return "\(currentKey)=\(self.queryString(with: int))"
            } else if let decimal = value as? Decimal {
                return "\(currentKey)=\(self.queryString(with: decimal))"
            } else if let decimal = value as? Double {
                return "\(currentKey)=\(self.queryString(with: decimal))"
            } else if let queryRepresentable = value as? URLQueryRespresentable {
                return "\(currentKey)=\(self.queryString(with: queryRepresentable))"
            } else if let array: [String] = value as? [String] {
                return self.queryString(with: array, key: currentKey)
            } else if let array: [[String: Any]] = value as? [[String: Any]] {
                return self.queryString(with: array, key: currentKey)
            } else if let dictionary: [String: Any] = value as? [String: Any] {
                return self.queryString(with: dictionary, parentKey: currentKey)
            } else {
                return nil
            }
        }
        .sorted()
        .joined(separator: "&")
    }

    private func queryString(with value: URLQueryRespresentable) -> String {
        if let int: Int = value as? Int {
            return String(int)
        } else if let float: Float = value as? Float {
            return String(float)
        } else if let double: Double = value as? Double {
            return String(double)
        } else if let decimal: Decimal = value as? Decimal {
            return "\(decimal)"
        } else if let string: String = value as? String {
            if options.contains(.urlEncoding) {
                let generalDelimitersToEncode = "#[]@:"
                let subDelimitersToEncode = "!$&'()*+,;="
                let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
                let allowedCharacterSet = CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
                return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
            } else {
                return string
            }
        } else {
            return ""
        }
    }

    private func queryString(with array: [URLQueryRespresentable], key: String) -> String {
        array.enumerated()
            .map { (offset: Int, element: URLQueryRespresentable) -> String in
                "\(key)[\(offset)]=\(self.queryString(with: element))"
            }
            .joined(separator: "&")
    }

    private func queryString(with array: [[String: Any]], key: String) -> String {
        array.enumerated()
            .compactMap { (offset: Int, element: [String: Any]) -> String? in
                let parentKey: String = "\(key)[\(offset)]"
                return self.queryString(with: element, parentKey: parentKey)
            }
            .joined(separator: "&")
    }
}

