//
//  PreferenceKitReminders.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-10-04.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(EventKit) && canImport(SwiftUI)
import EventKit
import PreferenceKit
import SwiftUI

public extension PreferenceKitPrivacyPermission {
    /// The Reminders capability and its current EventKit authorization state.
    static var reminders: PreferenceKitPrivacyPermission {
        .init(
            id: "reminders",
            name: "Reminders",
            symbolName: "checklist",
            backgroundColor: .orange,
            usageDescriptionKeys: [
                "NSRemindersFullAccessUsageDescription",
                "NSRemindersUsageDescription"
            ],
            previewUsageDescription: "Allow reminders access to create tasks."
        ) {
            switch EKEventStore.authorizationStatus(for: .reminder) {
            case .notDetermined: .notDetermined
            case .restricted: .restricted
            case .denied: .denied
            case .authorized, .fullAccess, .writeOnly: .authorized
            @unknown default: .unavailable
            }
        }
    }
}
#endif
