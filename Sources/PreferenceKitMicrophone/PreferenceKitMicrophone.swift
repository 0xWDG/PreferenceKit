//
//  PreferenceKitMicrophone.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-10-04.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(AVFoundation) && canImport(SwiftUI)
import AVFoundation
import PreferenceKit
import SwiftUI

public extension PreferenceKitPrivacyPermission {
    /// The Microphone capability and its current AVFoundation authorization state.
    static var microphone: PreferenceKitPrivacyPermission {
        .init(
            id: "microphone",
            name: "Microphone",
            symbolName: "mic.fill",
            backgroundColor: .red,
            usageDescriptionKeys: ["NSMicrophoneUsageDescription"],
            previewUsageDescription: "Allow microphone access to record voice notes."
        ) {
            switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .notDetermined: .notDetermined
            case .restricted: .restricted
            case .denied: .denied
            case .authorized: .authorized
            @unknown default: .unavailable
            }
        }
    }
}
#endif
