//
//  RamenToCoffeeApp.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/01/25.
//

import SwiftUI

let logger = Logger()

@main
struct RamenToCoffeeApp: App {
    var body: some Scene {
        WindowGroup {
            GourmetSearchView(viewModel: .init())
        }
    }
}
