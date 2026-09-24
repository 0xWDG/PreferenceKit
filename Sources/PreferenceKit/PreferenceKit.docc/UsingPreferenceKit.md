# Using PreferenceKit

@Metadata {
    @PageKind(article)
}

Create a settings screen by configuring ``PreferenceKit`` with your app's
support and legal information.

## Add a settings screen

Pass your app's privacy policy, support email, changelog, acknowledgements, and
social-media profiles to ``PreferenceKit``. Supply `nil` for an optional item
to hide it. `changeLog` and `acknowledgements` are required parameters so the
call site makes that choice explicit.

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

The top section appears after the update information and before the built-in
application details. The bottom section appears after developer links. Use
standard SwiftUI controls, and provide their accessibility labels and hints as
you would in any settings form.

## Supply support information

Setting `supportEmail` adds a Feedback button. PreferenceKit gathers the
available log text before presenting the system mail composer. If the device
cannot send mail, it opens a prefilled `mailto:` URL instead. Give users a
support address that you monitor.

`createdBy` supports Markdown, so you can credit a person or organization with
a link:

```swift
PreferenceKit(
    createdBy: "[Example Studio](https://example.com)",
    changeLog: nil,
    acknowledgements: nil,
    topContent: { EmptyView() },
    bottomContent: { EmptyView() }
)
```

## Privacy policy behavior

When `privacyPolicyURL` is present, PreferenceKit adds a Privacy Policy row.
On platforms and OS versions that support the packaged web view, selecting the
row presents the policy in-app. Otherwise, it opens the policy in the system
browser. The in-app reader also has a toolbar button that opens the same URL in
the system browser.

## Next steps

For supported profile formats and the public configuration models, see
<doc:Configuration>.
