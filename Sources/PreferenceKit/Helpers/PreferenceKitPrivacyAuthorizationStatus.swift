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
#if canImport(AVFoundation)
import AVFoundation
#endif
#if canImport(Contacts)
import Contacts
#endif
#if canImport(CoreLocation)
import CoreLocation
#endif
#if canImport(EventKit)
import EventKit
#endif
#if canImport(Photos)
import Photos
#endif
#if canImport(Speech)
import Speech
#endif
#if canImport(UserNotifications)
import UserNotifications
#endif

/// A privacy authorization state normalized across Apple's capability frameworks.
enum PreferenceKitPrivacyAuthorizationStatus {
    case notDetermined
    case denied
    case restricted
    case authorized
    case limited
    case provisional
    case unavailable

    /// The concise status displayed in the privacy card.
    var displayName: String {
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

    /// The semantic tint associated with the authorization state.
    var tint: Color {
        switch self {
        case .authorized, .provisional: .green
        case .limited: .orange
        case .denied, .restricted: .red
        case .notDetermined, .unavailable: .secondary
        }
    }
}

extension PreferenceKitPrivacyPermission {
    /// Reads the system authorization state without presenting a permission prompt.
    var authorizationStatus: PreferenceKitPrivacyAuthorizationStatus {
        get async {
            switch self {
            case .camera: cameraAuthorizationStatus
            case .microphone: microphoneAuthorizationStatus
            case .photos: photosAuthorizationStatus
            case .location: locationAuthorizationStatus
            case .notifications: await notificationAuthorizationStatus
            case .contacts: contactsAuthorizationStatus
            case .calendar: calendarAuthorizationStatus
            case .reminders: remindersAuthorizationStatus
            case .speechRecognition: speechRecognitionAuthorizationStatus
            }
        }
    }

    /// The current camera authorization state.
    private var cameraAuthorizationStatus: PreferenceKitPrivacyAuthorizationStatus {
#if canImport(AVFoundation)
        PreferenceKitPrivacyAuthorizationStatus(AVCaptureDevice.authorizationStatus(for: .video))
#else
        .unavailable
#endif
    }

    /// The current microphone authorization state.
    private var microphoneAuthorizationStatus: PreferenceKitPrivacyAuthorizationStatus {
#if canImport(AVFoundation)
        PreferenceKitPrivacyAuthorizationStatus(AVCaptureDevice.authorizationStatus(for: .audio))
#else
        .unavailable
#endif
    }

    /// The current photo-library authorization state.
    private var photosAuthorizationStatus: PreferenceKitPrivacyAuthorizationStatus {
#if canImport(Photos)
        PreferenceKitPrivacyAuthorizationStatus(PHPhotoLibrary.authorizationStatus(for: .readWrite))
#else
        .unavailable
#endif
    }

    /// The current location authorization state.
    private var locationAuthorizationStatus: PreferenceKitPrivacyAuthorizationStatus {
#if canImport(CoreLocation)
#if os(macOS)
        PreferenceKitPrivacyAuthorizationStatus(CLLocationManager().authorizationStatus)
#else
        PreferenceKitPrivacyAuthorizationStatus(CLLocationManager.authorizationStatus())
#endif
#else
        .unavailable
#endif
    }

    /// The current notification authorization state.
    private var notificationAuthorizationStatus: PreferenceKitPrivacyAuthorizationStatus {
        get async {
#if canImport(UserNotifications)
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            return PreferenceKitPrivacyAuthorizationStatus(settings.authorizationStatus)
#else
            return .unavailable
#endif
        }
    }

    /// The current contacts authorization state.
    private var contactsAuthorizationStatus: PreferenceKitPrivacyAuthorizationStatus {
#if canImport(Contacts)
        PreferenceKitPrivacyAuthorizationStatus(CNContactStore.authorizationStatus(for: .contacts))
#else
        .unavailable
#endif
    }

    /// The current calendar authorization state.
    private var calendarAuthorizationStatus: PreferenceKitPrivacyAuthorizationStatus {
#if canImport(EventKit)
        PreferenceKitPrivacyAuthorizationStatus(EKEventStore.authorizationStatus(for: .event))
#else
        .unavailable
#endif
    }

    /// The current reminders authorization state.
    private var remindersAuthorizationStatus: PreferenceKitPrivacyAuthorizationStatus {
#if canImport(EventKit)
        PreferenceKitPrivacyAuthorizationStatus(EKEventStore.authorizationStatus(for: .reminder))
#else
        .unavailable
#endif
    }

    /// The current speech-recognition authorization state.
    private var speechRecognitionAuthorizationStatus: PreferenceKitPrivacyAuthorizationStatus {
#if canImport(Speech)
        PreferenceKitPrivacyAuthorizationStatus(SFSpeechRecognizer.authorizationStatus())
#else
        .unavailable
#endif
    }
}

#if canImport(AVFoundation)
private extension PreferenceKitPrivacyAuthorizationStatus {
    /// Normalizes camera and microphone authorization values.
    init(_ status: AVAuthorizationStatus) {
        switch status {
        case .notDetermined: self = .notDetermined
        case .restricted: self = .restricted
        case .denied: self = .denied
        case .authorized: self = .authorized
        @unknown default: self = .unavailable
        }
    }
}
#endif

#if canImport(Photos)
private extension PreferenceKitPrivacyAuthorizationStatus {
    /// Normalizes photo-library authorization values.
    init(_ status: PHAuthorizationStatus) {
        switch status {
        case .notDetermined: self = .notDetermined
        case .restricted: self = .restricted
        case .denied: self = .denied
        case .authorized: self = .authorized
        case .limited: self = .limited
        @unknown default: self = .unavailable
        }
    }
}
#endif

#if canImport(CoreLocation)
private extension PreferenceKitPrivacyAuthorizationStatus {
    /// Normalizes location authorization values.
    init(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: self = .notDetermined
        case .restricted: self = .restricted
        case .denied: self = .denied
        case .authorizedAlways, .authorizedWhenInUse: self = .authorized
        @unknown default: self = .unavailable
        }
    }
}
#endif

#if canImport(UserNotifications)
private extension PreferenceKitPrivacyAuthorizationStatus {
    /// Normalizes notification authorization values.
    init(_ status: UNAuthorizationStatus) {
        switch status {
        case .notDetermined: self = .notDetermined
        case .denied: self = .denied
        case .authorized, .ephemeral: self = .authorized
        case .provisional: self = .provisional
        @unknown default: self = .unavailable
        }
    }
}
#endif

#if canImport(Contacts)
private extension PreferenceKitPrivacyAuthorizationStatus {
    /// Normalizes contacts authorization values.
    init(_ status: CNAuthorizationStatus) {
        switch status {
        case .notDetermined: self = .notDetermined
        case .restricted: self = .restricted
        case .denied: self = .denied
        case .authorized: self = .authorized
        @unknown default: self = .unavailable
        }
    }
}
#endif

#if canImport(EventKit)
private extension PreferenceKitPrivacyAuthorizationStatus {
    /// Normalizes calendar and reminders authorization values.
    init(_ status: EKAuthorizationStatus) {
        switch status {
        case .notDetermined: self = .notDetermined
        case .restricted: self = .restricted
        case .denied: self = .denied
        case .authorized, .fullAccess, .writeOnly: self = .authorized
        @unknown default: self = .unavailable
        }
    }
}
#endif

#if canImport(Speech)
private extension PreferenceKitPrivacyAuthorizationStatus {
    /// Normalizes speech-recognition authorization values.
    init(_ status: SFSpeechRecognizerAuthorizationStatus) {
        switch status {
        case .notDetermined: self = .notDetermined
        case .denied: self = .denied
        case .restricted: self = .restricted
        case .authorized: self = .authorized
        @unknown default: self = .unavailable
        }
    }
}
#endif
#endif
