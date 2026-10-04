//
//  PreferenceKitCamera.swift
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
    /// The Camera capability and its current AVFoundation authorization state.
    static var camera: PreferenceKitPrivacyPermission {
        .init(
            id: "camera",
            name: "Camera",
            symbolName: "camera.fill",
            backgroundColor: .gray,
            usageDescriptionKeys: ["NSCameraUsageDescription"],
            previewUsageDescription: "Allow camera access to scan receipts."
        ) {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
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
