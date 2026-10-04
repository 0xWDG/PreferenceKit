//
//  PreferenceKitContacts.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-10-04.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(Contacts) && canImport(SwiftUI)
import Contacts
import PreferenceKit
import SwiftUI

public extension PreferenceKitPrivacyPermission {
    /// The Contacts capability and its current Contacts authorization state.
    static var contacts: PreferenceKitPrivacyPermission {
        .init(
            id: "contacts",
            name: "Contacts",
            symbolName: "person.crop.circle",
            backgroundColor: .gray,
            usageDescriptionKeys: ["NSContactsUsageDescription"],
            previewUsageDescription: "Allow contact access to choose people to invite."
        ) {
            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .notDetermined: .notDetermined
            case .restricted, .limited: .restricted
            case .denied: .denied
            case .authorized: .authorized
            @unknown default: .unavailable
            }
        }
    }
}
#endif
