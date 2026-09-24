//
//  PreferenceKitHeaderSection.swift
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

struct PreferenceKitHeaderSection: View {
    let createdBy: String?

    @ScaledMetric(relativeTo: .title)
    private var appIconSize: CGFloat = 124

    var body: some View {
        Section {
            VStack(alignment: .center) {
                PKAppInfo.appIcon
                    .resizable()
                    .clipShape(.rect(cornerRadius: 24))
                    .frame(width: appIconSize, height: appIconSize)

                Text(PKAppInfo.appName)
                    .font(.title)

                if let createdBy {
                    HStack(spacing: 2) {
                        Text("Created by", bundle: Bundle.module)
                        Text(.init(createdBy))
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
#if os(iOS)
        .listRowSeparator(.hidden)
#endif
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    Form {
        PreferenceKitHeaderSection(createdBy: "[Wesley de Groot](https://wesleydegroot.nl)")
    }
}
#endif
#endif
