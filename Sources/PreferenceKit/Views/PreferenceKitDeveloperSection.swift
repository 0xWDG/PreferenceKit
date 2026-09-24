//
//  PreferenceKitDeveloperSection.swift
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

struct PreferenceKitDeveloperSection: View {
    let socialMediaLinks: [SocialMediaLink]
    @Binding private var developerURL: URL?

    init(socialMediaLinks: [SocialMediaLink], developerURL: Binding<URL?>) {
        self.socialMediaLinks = socialMediaLinks.filter { $0.url != nil }
        _developerURL = developerURL
    }

    var body: some View {
        Section {
            ForEach(socialMediaLinks) { link in
                SocialMediaLinkRow(link: link)
            }

            if let developerURL {
                Button {
                    openURL(developerURL)
                } label: {
                    Label {
                        Text("More apps from the developer", bundle: Bundle.module)
                    } icon: {
                        Image(systemName: "info.bubble")
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        } header: {
            Label {
                Text("About the developer", bundle: Bundle.module)
            } icon: {
                Image(systemName: "person")
                    .accessibilityHidden(true)
            }
        }
        .task {
            if developerURL == nil {
                developerURL = await PKAppInfo.developerURL
            }
        }
    }
}

private struct SocialMediaLinkRow: View {
    let link: SocialMediaLink

    var body: some View {
        if let url = link.url {
            Button {
                openURL(url)
            } label: {
                Label {
                    Text(link.platform.displayName)
                } icon: {
                    if let assetName = link.platform.assetName {
                        Image(decorative: assetName, bundle: Bundle.module)
                    } else {
                        Image(systemName: "globe")
                            .accessibilityHidden(true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    Form {
        PreferenceKitDeveloperSection(
            socialMediaLinks: [
                .init(platform: .github, profile: "0xWDG"),
                .init(platform: .website, profile: "https://wesleydegroot.nl")
            ],
            developerURL: .constant(URL(string: "https://apps.apple.com/developer/id602359900"))
        )
    }
}
#endif
#endif
