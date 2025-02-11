//
//  ContentView.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/01/25.
//

import SwiftUI

struct GourmetSearchView: View {
    @StateObject
    var viewModel: GourmetSearchViewModel = .init()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            viewModel.checkLocationServicesEnabled()
        }
    }
}

#Preview {
    GourmetSearchView()
}
