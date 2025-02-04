//
//  Logger.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/02.
//

import Foundation
import os

private let _logger = os.Logger()

struct Logger {
    func debug(_ message: (some CustomStringConvertible)?) {
        #if DEBUG
        _logger.debug("\(message?.description ?? "")")
        #endif
    }

    func debug(_ message0: (some CustomStringConvertible)?, _ message1: (some CustomStringConvertible)?) {
        #if DEBUG
        _logger.debug("\(message0?.description ?? ""), \(message1?.description ?? "")")
        #endif
    }

    func error(_ error: Error?) {
        #if DEBUG
        _logger.error("\(error?.localizedDescription ?? "")")
        #endif
    }

    func error(_ message: some CustomStringConvertible, _ error: Error?) {
        #if DEBUG
        _logger.error("\(message.description), \(error?.localizedDescription ?? "")")
        #endif
    }

    func error(_ data: Data) {
        #if DEBUG
        _logger.error("\(String(data: data, encoding: .utf8) ?? "")")
        #endif
    }
}
