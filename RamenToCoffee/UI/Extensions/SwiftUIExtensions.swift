//
//  SwiftUIExtensions.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/17.
//

import SwiftUI

extension View {
    @MainActor
    func loading(isPresented: Bool, dimmed: Bool = false) -> some View {
        disabled(isPresented, dimmed: dimmed)
            .overlay {
                if isPresented {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
    }

    @MainActor
    func loading(isPresented: Bool, dimmed: Bool = false, title: LocalizedStringKey) -> some View {
        disabled(isPresented, dimmed: dimmed)
            .overlay {
                if isPresented {
                    ProgressView(title)
                        .progressViewStyle(.circular)
                        .foregroundStyle(.white)
                        .padding()
                        .tint(.white)
                        .background(.gray)
                        .cornerRadius(8)
                        .scaleEffect(1.2)
                }
            }
    }
}

extension View {
    @ViewBuilder
    func hidden(_ where: @autoclosure () -> Bool) -> some View {
        opacity(`where`() ? 0 : 1)
            .disabled(`where`())
    }

    func disabled(_ disabled: Bool, dimmed: Bool, color: Color? = nil) -> some View {
        self.disabled(disabled)
            .dimmed(disabled && dimmed, color: color)
    }

    @ViewBuilder
    func dimmed(_ dimmed: Bool, color: Color? = nil) -> some View {
        if let color {
            opacity(dimmed ? 0.7 : 1)
                .background(dimmed ? color.opacity(0.2) : Color.white)
        } else {
            opacity(dimmed ? 0.3 : 1)
        }
    }
}
