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

import Foundation
#if canImport(UserNotifications)
import UserNotifications
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
/// A privacy capability that PreferenceKit can infer from an app's Info.plist.
enum PreferenceKitPrivacyPermission: String, CaseIterable, Identifiable {
    case camera, microphone, photos, location, notifications
    case contacts, calendar, reminders, speechRecognition

    /// A stable identifier suitable for use in SwiftUI collections.
    var id: String { rawValue }

    #if canImport(SwiftUI)
    /// The user-facing capability name for SwiftUI views.
    ///
    /// This value remains conditional because `LocalizedStringKey` is a
    /// SwiftUI type and the package also supports platforms without SwiftUI.
    var name: LocalizedStringKey {
        switch self {
        case .camera: "Camera"
        case .microphone: "Microphone"
        case .photos: "Photos"
        case .location: "Location"
        case .notifications: "Notifications"
        case .contacts: "Contacts"
        case .calendar: "Calendar"
        case .reminders: "Reminders"
        case .speechRecognition: "Speech Recognition"
        }
    }
    #endif

    /// The SF Symbol that represents the capability in settings navigation.
    var symbolName: String {
        switch self {
        case .camera: "camera.fill"
        case .microphone: "mic.fill"
        case .photos: "photo.on.rectangle.angled"
        case .location: "location.fill"
        case .notifications: "bell.fill"
        case .contacts: "person.crop.circle.fill"
        case .calendar: "calendar"
        case .reminders: "checklist"
        case .speechRecognition: "waveform"
        }
    }

#if canImport(SwiftUI)
    /// The app-inspired tile color associated with the represented permission.
    var backgroundColor: Color {
        switch self {
        case .camera: .black
        case .microphone: .orange
        case .photos: .blue
        case .location: .blue
        case .notifications: .red
        case .contacts: .gray
        case .calendar: .red
        case .reminders: .white
        case .speechRecognition: .orange
        }
    }
#endif

    /// The package asset name for permissions with supplied app-icon artwork.
    var iconAssetName: String? {
        switch self {
        case .contacts: "privacy.contacts"
        case .calendar: "privacy.calendar"
        default: nil
        }
    }

    /// The nonempty explanation supplied by the host application.
    ///
    /// This reads localized Info.plist content first so people see the same
    /// reason for access that the system permission prompt presents.
    var usageDescription: String {
        usageDescription(in: .main)
            ?? (Self.isRunningInPreview ? previewUsageDescription : defaultUsageDescription)
    }

    /// The Info.plist keys that declare the capability's reason for use.
    var usageDescriptionKeys: [String] {
        switch self {
        case .camera: ["NSCameraUsageDescription"]
        case .microphone: ["NSMicrophoneUsageDescription"]
        case .photos: ["NSPhotoLibraryUsageDescription"]
        case .location: ["NSLocationWhenInUseUsageDescription"]
        case .notifications: []
        case .contacts: ["NSContactsUsageDescription"]
        case .calendar: ["NSCalendarsFullAccessUsageDescription", "NSCalendarsUsageDescription"]
        case .reminders: ["NSRemindersFullAccessUsageDescription", "NSRemindersUsageDescription"]
        case .speechRecognition: ["NSSpeechRecognitionUsageDescription"]
        }
    }

    /// Finds capabilities declared in `bundle`, plus requested notifications.
    ///
    /// - Parameter bundle: The app bundle that owns usage descriptions.
    /// - Returns: Every capability that should appear in the Privacy destination.
    static func available(in bundle: Bundle) async -> [Self] {
        if isRunningInPreview {
            return allCases
        }

        let declaredPermissions = allCases.filter { $0.usageDescription(in: bundle) != nil }
        let notificationPermissionWasRequested = await notificationPermissionWasRequested()

        return allCases.filter {
            declaredPermissions.contains($0)
                || ($0 == .notifications && notificationPermissionWasRequested)
        }
    }

    /// Whether the view hierarchy is currently rendered by an Xcode preview.
    ///
    /// Previews do not run with the host application's privacy declarations or
    /// authorization history, so they instead present every supported capability.
    private static var isRunningInPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    /// A concise explanation for permissions that do not use an Info.plist key.
    private var defaultUsageDescription: String {
        self == .notifications
            ? "Notification settings let you control how this app may alert you."
            : ""
    }

    /// The representative purpose shown for a capability in Xcode previews.
    private var previewUsageDescription: String {
        switch self {
        case .camera:
            "Camera access lets this app capture photos and video."
        case .microphone:
            "Microphone access lets this app record audio."
        case .photos:
            "Photo library access lets this app select and save photos."
        case .location:
            "Location access lets this app provide location-aware features."
        case .notifications:
            "Notification settings let you control how this app may alert you."
        case .contacts:
            "Contacts access lets this app find people you choose to share with."
        case .calendar:
            "Calendar access lets this app show and create relevant events."
        case .reminders:
            "Reminders access lets this app create and manage reminders."
        case .speechRecognition:
            "Speech recognition lets this app turn spoken words into text."
        }
    }

    /// Reports whether the app has requested notification authorization before.
    private static func notificationPermissionWasRequested() async -> Bool {
#if canImport(UserNotifications)
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus != .notDetermined
#else
        false
#endif
    }

    /// Reads a capability's first nonempty localized usage description.
    private func usageDescription(in bundle: Bundle) -> String? {
        for key in usageDescriptionKeys {
            let value = bundle.localizedInfoDictionary?[key] as? String
                ?? bundle.object(forInfoDictionaryKey: key) as? String
            guard let value else { continue }

            let description = value.trimmingCharacters(in: .whitespacesAndNewlines)
            if !description.isEmpty {
                return description
            }
        }

        return nil
    }
}
