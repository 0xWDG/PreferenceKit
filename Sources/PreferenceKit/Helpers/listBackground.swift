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
#if canImport(AppKit)
        Color(nsColor: .controlBackgroundColor)
#elseif canImport(UIKit)
        Color(uiColor: .systemGroupedBackground)
#else
        Color.lightGray
#endif
    }
}
#endif
