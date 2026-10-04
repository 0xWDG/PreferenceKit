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
#if canImport(UserNotifications)
import UserNotifications
#endif

/// Describes an opt-in capability displayed in PreferenceKit's Privacy destination.
public struct PreferenceKitPrivacyPermission: Identifiable, Equatable {
    public let id: String
    let name: LocalizedStringKey
    let symbolName: String
    let backgroundColor: Color
    let iconAssetName: String?
    let usageDescriptionKeys: [String]
    let previewUsageDescription: String
    let authorizationStatusProvider: () async -> PreferenceKitPrivacyAuthorizationStatus

    /// Creates a capability supplied by an optional companion product.
    public init(
        id: String,
        name: LocalizedStringKey,
        symbolName: String,
        backgroundColor: Color,
        iconAssetName: String? = nil,
        usageDescriptionKeys: [String],
        previewUsageDescription: String,
        authorizationStatus: @escaping () async -> PreferenceKitPrivacyAuthorizationStatus
    ) {
        self.id = id
        self.name = name
        self.symbolName = symbolName
        self.backgroundColor = backgroundColor
        self.iconAssetName = iconAssetName
        self.usageDescriptionKeys = usageDescriptionKeys
        self.previewUsageDescription = previewUsageDescription
        authorizationStatusProvider = authorizationStatus
    }

    var usageDescription: String { usageDescription(in: .main) ?? (Self.isPreview ? previewUsageDescription : "") }

    static func available(in bundle: Bundle, permissions: [Self]) async -> [Self] {
        if isPreview { return permissions }
        return permissions.filter { $0.usageDescription(in: bundle) != nil }
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
