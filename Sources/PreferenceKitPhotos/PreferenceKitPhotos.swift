//
//  PreferenceKitPhotos.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-10-04.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(Photos) && canImport(SwiftUI)
import Photos
import PreferenceKit
import SwiftUI

public extension PreferenceKitPrivacyPermission {
    /// The Photos capability, including its limited-library authorization state.
    static var photos: PreferenceKitPrivacyPermission {
        .init(
            id: "photos",
            name: "Photos",
            symbolName: "photo.on.rectangle",
            backgroundColor: .blue,
            usageDescriptionKeys: ["NSPhotoLibraryUsageDescription"],
            previewUsageDescription: "Allow photo access to attach images to entries."
        ) {
            switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
            case .notDetermined: .notDetermined
            case .restricted: .restricted
            case .denied: .denied
            case .authorized: .authorized
            case .limited: .limited
            @unknown default: .unavailable
            }
        }
    }
}
#endif
