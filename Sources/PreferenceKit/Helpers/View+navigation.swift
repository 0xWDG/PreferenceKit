//
//  View+navigation.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2025-11-19.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

extension View {
    @ViewBuilder
    func navigation(title: String, subtitle: String) -> some View {
        if #available(iOS 26.0, macCatalyst 14.0, macOS 11.0, *) {
            self
                .navigationTitle(title)
                .navigationSubtitle(subtitle)
        } else {
            self
                .navigationTitle(title)
        }
    }
}
#endif
