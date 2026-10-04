//
//  PreferenceKitPrivacyContentBuilder.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-10-04.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// Builds optional custom content for PreferenceKit's Privacy destination.
///
/// Supply one row, `Section`, or `Group` through `PreferenceKit`'s
/// `privacyContent` parameter. Wrap multiple related items in a `Section` or
/// `Group` so they retain their intended List structure.
@resultBuilder
public enum PreferenceKitPrivacyContentBuilder {
    /// Produces no custom privacy content.
    public static func buildBlock() -> AnyView? {
        nil
    }

    /// Type-erases one custom privacy view for storage by PreferenceKit.
    ///
    /// - Parameter content: The row, section, or grouped content to display.
    /// - Returns: Type-erased custom content.
    public static func buildBlock<Content: View>(_ content: Content) -> AnyView? {
        AnyView(content)
    }

    /// Allows an optional custom privacy view.
    ///
    /// - Parameter component: Content produced by a conditional branch.
    /// - Returns: The component unchanged.
    public static func buildOptional(_ component: AnyView?) -> AnyView? {
        component
    }

    /// Supports the first branch of a conditional privacy view.
    ///
    /// - Parameter component: Content from the first branch.
    /// - Returns: The component unchanged.
    public static func buildEither(first component: AnyView?) -> AnyView? {
        component
    }

    /// Supports the second branch of a conditional privacy view.
    ///
    /// - Parameter component: Content from the second branch.
    /// - Returns: The component unchanged.
    public static func buildEither(second component: AnyView?) -> AnyView? {
        component
    }
}
#endif
