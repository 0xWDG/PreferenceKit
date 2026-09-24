# PreferenceKit

PreferenceKit provides a ready-made SwiftUI settings screen with application
information, update links, acknowledgements, changelog entries, support
feedback, privacy policy links, and developer social-media links.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FPreferenceKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/0xWDG/PreferenceKit)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FPreferenceKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/0xWDG/PreferenceKit)

[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)

![License](https://img.shields.io/github/license/0xWDG/PreferenceKit)

## Requirements

- Swift 6.0+ (Xcode 16+)
- iOS 15+, macOS 12+, watchOS 8+, tvOS 15+

## Installation (Package.swift)

```swift
dependencies: [
    .package(url: "https://github.com/0xWDG/PreferenceKit.git", branch: "main"),
],
targets: [
    .target(name: "MyTarget", dependencies: [
        .product(name: "PreferenceKit", package: "PreferenceKit"),
    ]),
]
```

## Installation (Xcode)

1. In Xcode, open your project and navigate to **File > Swift Packages > Add Package Dependency...**
2. Paste the repository URL (`https://github.com/0xWDG/PreferenceKit`) and click **Next**.
3. Click **Finish**.

## Usage

```swift
import SwiftUI
import PreferenceKit

struct ContentView: View {
    @State private var sendsDiagnostics = true

    var body: some View {
        PreferenceKit(
            createdBy: "[Example Studio](https://example.com)",
            privacyPolicyURL: URL(string: "https://example.com/privacy"),
            supportEmail: "support@example.com",
            socialMediaLinks: [
                .init(platform: .github, profile: "example"),
                .init(platform: .mastodon, profile: "@example@mastodon.social"),
                .init(platform: .website, profile: "https://example.com")
            ],
            changeLog: [
                .init(version: "1.2.0", date: "2026-09-24", text: "Improved settings.")
            ],
            acknowledgements: [
                .init(
                    name: "Example Dependency",
                    copyright: "Example Authors",
                    licence: "MIT",
                    url: "https://github.com/example/dependency"
                )
            ]
        ) {
            Section("Support") {
                Toggle("Include diagnostics in feedback", isOn: $sendsDiagnostics)
            }
        } bottomContent: {
            Section {
                Text("Thanks for using Example App.")
            }
        }
    }
}
```

`privacyPolicyURL` is displayed in an in-app web view where supported; on other
platforms or OS versions, PreferenceKit opens the URL in the system browser.

## Configuration

All configuration is optional except `changeLog` and `acknowledgements`, which
accept `nil` when the corresponding row should be hidden.

| Parameter | Effect |
| --- | --- |
| `createdBy` | Displays an attributed Markdown link below the app name. |
| `privacyPolicyURL` | Adds a Privacy Policy row. |
| `supportEmail` | Adds a Feedback row and includes app and diagnostic details. |
| `socialMediaLinks` | Adds links for developer profiles and communities. |
| `changeLog` | Adds a Changelog destination. |
| `acknowledgements` | Adds an Acknowledgements destination. |
| `topContent` / `bottomContent` | Places your own `Section` views around the built-in content. |

Use a platform-specific profile identifier for social media when possible—for
example, `"example"` for GitHub or `"@example@mastodon.social"` for Mastodon.
You can also pass a complete HTTP or HTTPS URL for custom community, invite,
or profile destinations.

See the [DocC usage guide](Sources/PreferenceKit/PreferenceKit.docc/UsingPreferenceKit.md)
and [configuration reference](Sources/PreferenceKit/PreferenceKit.docc/Configuration.md)
for details.

## Screenshot

<img width="296" height="487" alt="image" src="https://github.com/user-attachments/assets/838fcd55-05c7-4efd-a4c0-fda3c9b214eb" />

## Contact

[https://wesleydegroot.nl](https://wesleydegroot.nl)

Interested learning more about Swift? [Check out my blog](https://wesleydegroot.nl/blog/).
