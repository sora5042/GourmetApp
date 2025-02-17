//
//  Alignment.swift
//  RamenToCoffee
//
//  Created by Sora Oya on 2025/02/13.
//

import SwiftUI

enum Alignment {
    case left, right, center
}

extension View {
    @ViewBuilder
    func alignment(_ alignment: Alignment) -> some View {
        switch alignment {
        case .left:
            modifier(Left())
        case .center:
            modifier(Center())
        case .right:
            modifier(Right())
        }
    }
}

// MARK: -

struct Left: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer(minLength: 0)
        }
    }
}

struct Right: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer(minLength: 0)
            content
        }
    }
}

struct Center: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer(minLength: 0)
            content
            Spacer(minLength: 0)
        }
    }
}
