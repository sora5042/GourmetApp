//
//  DateExtensions.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/02.
//

import Foundation

extension DateFormatter {
    public convenience init(calendar: Calendar.Identifier, locale: Locale = .init(identifier: "en_US_POSIX")) {
        self.init()
        self.calendar = .init(identifier: calendar)
        self.locale = locale
    }

    public convenience init(dateFormat: String) {
        self.init(calendar: .gregorian)
        self.dateFormat = dateFormat
    }
}

extension Date {
    /// 日付から文字列に変換する
    /// - Parameter dateFormat: 日付のフォーマット
    /// - Returns: String
    public func formatted(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter(dateFormat: dateFormat)
        return formatter.string(from: self)
    }
}
