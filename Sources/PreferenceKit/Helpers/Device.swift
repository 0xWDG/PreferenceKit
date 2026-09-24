//
//  Device.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

/// Device information
///
/// Get information about the current running device.
/// This can be used to get the device model, OS version, etc.
enum Device {
    /// Obtain the machine hardware platform from the `uname()` unix command
    public static var model: String {
#if canImport(Darwin)
        var utsnameInstance = utsname()
        uname(&utsnameInstance)
        let optionalString: String? = withUnsafePointer(to: &utsnameInstance.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
                String(validatingCString: ptr)
            }
        }

        return optionalString ?? "N/A"
#else
        return "N/A"
#endif
    }

    /// Operating system version
    public static var osVersion: String {
        ProcessInfo.processInfo.operatingSystemVersionString
    }

    /// Device screen size
    /// - Note: On macOS, this returns the size of the main screen or `.zero` if no screen is available.
    public static var size: CGSize {
#if os(iOS) || os(tvOS) || os(visionOS)
        return UIScreen.main.bounds.size
#elseif os(macOS)
        return NSScreen.main?.frame.size ?? .zero
#else
        return .zero
#endif
    }

    /// Are we running on Carplay?
    public static var isCarplay: Bool {
#if canImport(UIKit) && os(iOS)
        if #available(iOS 16, *) {
            return UIApplication.shared.connectedScenes.filter {
                ($0 as? UIWindowScene)?.traitCollection.userInterfaceIdiom == .carPlay
            }.count >= 1
        } else {
            return UIScreen.screens.filter {
                $0.traitCollection.userInterfaceIdiom == .carPlay
            }.count >= 1
        }
#else
        return false
#endif
    }

}
