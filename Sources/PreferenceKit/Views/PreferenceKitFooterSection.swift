//
//  PreferenceKitFooterSection.swift
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

struct PreferenceKitFooterSection: View {
    var body: some View {
        Section {} footer: {
            Text(
                // swiftlint:disable:next line_length
                "\(PKAppInfo.appName) \(PKAppInfo.isDebugBuild ? "(Debug)" : "(AppStore)"), version: \(PKAppInfo.versionNumber), build: \(PKAppInfo.buildNumber).",
                bundle: Bundle.module
            )
        }
        .padding(.top, -25)
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    Form {
        PreferenceKitFooterSection()
    }
}
#endif
#endif
