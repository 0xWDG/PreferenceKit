//
//  PreferenceKitUpdateSection.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-09-24.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

struct PreferenceKitUpdateSection: View {
    let updateAvailable: Bool
    let appStoreVersion: String

    var body: some View {
        if updateAvailable {
            Section {
                Button {
                    Task {
                        await PKAppInfo.openAppStorePage()
                    }
                } label: {
                    Label {
                        VStack(alignment: .leading) {
                            Text("Update available")
                            Text("Update now to version \(appStoreVersion)!")
                        }
                    } icon: {
                        Image(systemName: "square.and.arrow.down.fill")
                            .accessibilityHidden(true)
                    }
                }
            }
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("Update Available") {
    Form {
        PreferenceKitUpdateSection(updateAvailable: true, appStoreVersion: "2.0")
    }
}
#endif
#endif
