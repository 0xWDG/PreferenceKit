//
//  PreferenceKitLocation.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-10-04.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(CoreLocation) && canImport(SwiftUI)
import CoreLocation
import PreferenceKit
import SwiftUI

public extension PreferenceKitPrivacyPermission {
    /// The When In Use Location capability and its current Core Location authorization state.
    static var location: PreferenceKitPrivacyPermission {
        .init(
            id: "location",
            name: "Location",
            symbolName: "location.fill",
            backgroundColor: .blue,
            usageDescriptionKeys: ["NSLocationWhenInUseUsageDescription"],
            previewUsageDescription: "Allow location access to show nearby events."
        ) {
            switch CLLocationManager().authorizationStatus {
            case .notDetermined: .notDetermined
            case .restricted: .restricted
            case .denied: .denied
            case .authorizedAlways, .authorizedWhenInUse: .authorized
            @unknown default: .unavailable
            }
        }
    }
}
#endif
