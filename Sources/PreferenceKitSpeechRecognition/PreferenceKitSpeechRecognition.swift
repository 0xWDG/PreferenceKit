//
//  PreferenceKitSpeechRecognition.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-10-04.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(Speech) && canImport(SwiftUI)
import PreferenceKit
import Speech
import SwiftUI

public extension PreferenceKitPrivacyPermission {
    /// The Speech Recognition capability and its current Speech authorization state.
    static var speechRecognition: PreferenceKitPrivacyPermission {
        .init(
            id: "speech-recognition",
            name: "Speech Recognition",
            symbolName: "waveform",
            backgroundColor: .purple,
            usageDescriptionKeys: ["NSSpeechRecognitionUsageDescription"],
            previewUsageDescription: "Allow speech recognition to transcribe spoken titles."
        ) {
            switch SFSpeechRecognizer.authorizationStatus() {
            case .notDetermined: .notDetermined
            case .denied: .denied
            case .restricted: .restricted
            case .authorized: .authorized
            @unknown default: .unavailable
            }
        }
    }
}
#endif
