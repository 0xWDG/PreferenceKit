//
//  PreferenceKitPrivacyPermission.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-10-04.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(SwiftUI)
import Foundation
import SwiftUI

/// Describes an opt-in capability displayed in PreferenceKit's Privacy destination.
public struct PreferenceKitPrivacyPermission: Identifiable, Equatable {
    public let id: String
    let name: LocalizedStringKey
    let symbolName: String
    let backgroundColor: Color
    let iconAssetName: String?
    let usageDescriptionKeys: [String]
    let previewUsageDescription: String
    let isAvailableWithoutUsageDescription: Bool
    /// Retrieves the authorization state on the main actor, where the privacy UI consumes it.
    let authorizationStatusProvider: @MainActor () async -> PreferenceKitPrivacyAuthorizationStatus

    /// Creates a capability supplied by an optional companion product.
    public init(
        id: String,
        name: LocalizedStringKey,
        symbolName: String,
        backgroundColor: Color,
        iconAssetName: String? = nil,
        usageDescriptionKeys: [String],
        previewUsageDescription: String,
        isAvailableWithoutUsageDescription: Bool = false,
        authorizationStatus: @escaping @MainActor () async -> PreferenceKitPrivacyAuthorizationStatus
    ) {
        self.id = id
        self.name = name
        self.symbolName = symbolName
        self.backgroundColor = backgroundColor
        self.iconAssetName = iconAssetName
        self.usageDescriptionKeys = usageDescriptionKeys
        self.previewUsageDescription = previewUsageDescription
        self.isAvailableWithoutUsageDescription = isAvailableWithoutUsageDescription
        authorizationStatusProvider = authorizationStatus
    }

    var usageDescription: String { usageDescription(in: .main) ?? (Self.isPreview ? previewUsageDescription : "") }

    /// Filters permissions to those declared by the supplied application bundle.
    ///
    /// The lookup is main-actor isolated because its result is installed directly in SwiftUI state.
    ///
    /// - Parameters:
    ///   - bundle: The bundle whose privacy usage-description keys are inspected.
    ///   - permissions: The capabilities to filter.
    /// - Returns: The capabilities available to display in the application's privacy destination.
    @MainActor static func available(in bundle: Bundle, permissions: [Self]) async -> [Self] {
        if isPreview { return permissions }
        return permissions.filter {
            $0.isAvailableWithoutUsageDescription || $0.usageDescription(in: bundle) != nil
        }
    }

    private static var isPreview: Bool { ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" }

    /// Compares capabilities by their stable identifier.
    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    private func usageDescription(in bundle: Bundle) -> String? {
        for key in usageDescriptionKeys {
            let value = bundle.localizedInfoDictionary?[key] as? String
                ?? bundle.object(forInfoDictionaryKey: key) as? String
            if let value = value?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty { return value }
        }
        return nil
    }
}

#endif
