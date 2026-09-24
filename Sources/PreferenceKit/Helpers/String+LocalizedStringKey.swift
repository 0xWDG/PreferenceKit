//
//  String+LocalizedStringKey.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-03-16.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

extension String {
    /// Creates a string by resolving a SwiftUI localized-string key.
    ///
    /// - Parameter string: The localized-string key to resolve.
    init(_ string: LocalizedStringKey) {
        self.init(
            NSLocalizedString(
                Mirror(reflecting: string)
                    .children
                    .first(where: { $0.label == "key" })?
                    .value as? String ?? "Unknown",
                comment: "None"
            )
        )
    }
}
#endif
