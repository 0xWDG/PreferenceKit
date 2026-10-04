//
//  PreferenceKitNotifications.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-10-04.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(SwiftUI) && canImport(UserNotifications)
import PreferenceKit
import SwiftUI
import UserNotifications

public extension PreferenceKitPrivacyPermission {
    /// The Notifications capability and its current User Notifications authorization state.
    static var notifications: PreferenceKitPrivacyPermission {
        .init(
            id: "notifications",
            name: "Notifications",
            symbolName: "bell.badge.fill",
            backgroundColor: .red,
            usageDescriptionKeys: [],
            previewUsageDescription: "Allow notifications to deliver reminders.",
            isAvailableWithoutUsageDescription: true
        ) {
            switch await UNUserNotificationCenter.current().notificationSettings().authorizationStatus {
            case .notDetermined: .notDetermined
            case .denied: .denied
            case .authorized, .ephemeral: .authorized
            case .provisional: .provisional
            @unknown default: .unavailable
            }
        }
    }
}
#endif
