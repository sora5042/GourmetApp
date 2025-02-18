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
    func loading(isPresented: Bool, dimmed: Bool = false, title: String) -> some View {
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

extension View {
    @MainActor
    @ViewBuilder
    func alert(_ error: Binding<Error?>) -> some View {
        switch error.wrappedValue {
        case let e as HotPepperGourmetAPIError:
            alert(
                isPresented: .init(value: error),
                title: "\(e.localizedDescription)",
                message: ""
            )
        case let e?:
            alert(
                isPresented: .init(value: error),
                title: "\(e.localizedDescription)",
                message: ""
            )
        default:
            self
        }
    }
}

extension View {
    func alert(isPresented: Binding<Bool>, title: Text, message: Text) -> some View {
        alert(
            title,
            isPresented: isPresented
        ) {
            Button("キャンセル") { isPresented.wrappedValue = false }
        } message: {
            message
        }
    }

    func alert(isPresented: Binding<Bool>, title: String, message: String) -> some View {
        alert(isPresented: isPresented, title: Text(title), message: Text(message))
    }
}

// MARK: - Binding

extension Binding where Value == Bool {
    init(value: Binding<(some Any)?>) {
        self.init(
            get: {
                value.wrappedValue != nil
            },
            set: {
                if !$0 {
                    value.wrappedValue = nil
                }
            }
        )
    }
}
