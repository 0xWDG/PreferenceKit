//
//  PreferenceKitPrivacyAuthorizationStatus.swift
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

/// A privacy authorization state normalized across capability-specific frameworks.
public enum PreferenceKitPrivacyAuthorizationStatus {
    /// The possible authorization states for a privacy capability.
    case notDetermined, denied, restricted, authorized, limited, provisional, unavailable

    /// The concise localized status displayed in a privacy card.
    var displayName: LocalizedStringKey {
        switch self {
        case .notDetermined: "Not Determined"
        case .denied: "Denied"
        case .restricted: "Restricted"
        case .authorized: "Access Granted"
        case .limited: "Limited Access"
        case .provisional: "Provisional Access"
        case .unavailable: "Unavailable"
        }
    }

    /// The semantic tint associated with the status.
    var tint: Color {
        switch self {
        case .authorized, .provisional: .green
        case .limited: .orange
        case .denied, .restricted: .red
        case .notDetermined, .unavailable: .secondary
        }
    }
}

#endif
