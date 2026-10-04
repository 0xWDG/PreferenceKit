//
//  PreferenceKitCalendar.swift
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
    /// The Calendar capability and its current EventKit authorization state.
    static var calendar: PreferenceKitPrivacyPermission {
        .init(
            id: "calendar",
            name: "Calendar",
            symbolName: "calendar",
            backgroundColor: .red,
            usageDescriptionKeys: [
                "NSCalendarsFullAccessUsageDescription",
                "NSCalendarsUsageDescription"
            ],
            previewUsageDescription: "Allow calendar access to add events."
        ) {
            switch EKEventStore.authorizationStatus(for: .event) {
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
