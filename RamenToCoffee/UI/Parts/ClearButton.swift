//
//  ClearButton.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/14.
//

import SwiftUI

struct ClearButton: View {
    var action: @MainActor () async -> Void

    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.gray)
        }
        .padding(.trailing, 8)
    }
}
