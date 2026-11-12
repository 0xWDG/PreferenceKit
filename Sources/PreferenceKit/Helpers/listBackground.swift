//
//  listBackground.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 24/09/2026.
//

#if canImport(SwiftUI)
import SwiftUI

extension Color {
    static var listBackground: Color {
#if canImport(UIKit) && !os(watchOS) && !os(tvOS)
        Color(uiColor: .systemGroupedBackground)
#elseif canImport(AppKit)
        Color(nsColor: .controlBackgroundColor)
#else
        Color.gray
#endif
    }
}
#endif
