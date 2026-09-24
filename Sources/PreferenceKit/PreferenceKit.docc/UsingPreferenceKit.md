# Using PreferenceKit

@Metadata {
    @PageKind(article)
}

Create a settings screen by configuring ``PreferenceKit`` with your app's
support and legal information.

## Add a settings screen

Pass your app's privacy policy, support email, changelog, acknowledgements, and
social-media profiles to ``PreferenceKit``. Supply `nil` for an optional item
to hide it.

```swift
import SwiftUI
import PreferenceKit

struct SettingsView: View {
    var body: some View {
        PreferenceKit(
            createdBy: "[Example Studio](https://example.com)",
            privacyPolicyURL: URL(string: "https://example.com/privacy"),
            supportEmail: "support@example.com",
            socialMediaLinks: [
                .init(platform: .github, profile: "example"),
                .init(platform: .website, profile: "https://example.com")
            ],
            changeLog: [
                .init(version: "1.0", text: "Initial release")
            ],
            acknowledgements: [
                .init(
                    name: "Example Dependency",
                    copyright: "Example Authors",
                    licence: "MIT"
                )
            ],
            topContent: { EmptyView() },
            bottomContent: { EmptyView() }
        )
    }
}
```

## Configure social-media links

Create ``SocialMediaLink`` values with a service and a profile identifier.
PreferenceKit builds the destination URL for each supported service. A complete
HTTP or HTTPS URL is kept as-is, which is useful for invitation and workspace
links.

```swift
let links: [SocialMediaLink] = [
    .init(platform: .github, profile: "example"),
    .init(platform: .mastodon, profile: "@example@mastodon.social"),
    .init(platform: .discord, profile: "https://discord.gg/example")
]
```

## Add custom sections

Use the `topContent` and `bottomContent` view builders to add app-specific
settings before or after PreferenceKit's built-in sections.

```swift
PreferenceKit(
    changeLog: nil,
    acknowledgements: nil
) {
    Section("Preferences") {
        Toggle("Send diagnostics", isOn: $sendsDiagnostics)
    }
} bottomContent: {
    Section {
        Text("Example App")
    }
}
```

## Privacy policy behavior

When `privacyPolicyURL` is present, PreferenceKit adds a Privacy Policy row.
On platforms and OS versions that support the packaged web view, selecting the
row presents the policy in-app. Otherwise, it opens the policy in the system
browser.
