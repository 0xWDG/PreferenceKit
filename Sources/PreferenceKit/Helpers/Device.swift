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

/// Device information
///
/// Get information about the current running device.
/// This can be used to get the device model, OS version, etc.
enum Device {
    /// Obtain the machine hardware platform from the `uname()` unix command
    static var model: String {
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
}
