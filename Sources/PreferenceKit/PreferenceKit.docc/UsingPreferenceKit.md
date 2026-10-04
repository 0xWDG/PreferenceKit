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

## Privacy permissions

PreferenceKit detects nonempty usage descriptions in the host app's
`Info.plist` for Camera, Microphone, Photos, Location, Contacts, Calendar,
Reminders, and Speech Recognition. When at least one is declared, it adds a
Privacy destination that shows the declared reason for each capability and, on
supported platforms, a Change button that opens the relevant Settings page.
Notifications are also included after notification authorization has been
requested; unlike the other capabilities, notifications do not have an
Info.plist usage-description key. Each detail view reads and displays the
current authorization state without showing a permission prompt.

> Important: Add purpose strings to the consuming app target's `Info.plist`,
> not to PreferenceKit. App Store Connect analyzes the final app binary, so a
> linked privacy API can require its corresponding key even when the app has
> not requested access yet. Each value must truthfully explain the feature
> that uses the protected data.

| Capability | Info.plist key | Example purpose string |
| --- | --- | --- |
| Camera | `NSCameraUsageDescription` | `This app uses the camera to scan receipts.` |
| Microphone | `NSMicrophoneUsageDescription` | `This app uses the microphone to record voice notes.` |
| Photos | `NSPhotoLibraryUsageDescription` | `This app lets you attach photos to entries.` |
| Location | `NSLocationWhenInUseUsageDescription` | `This app uses your location to show nearby events.` |
| Contacts | `NSContactsUsageDescription` | `This app lets you choose contacts to invite.` |
| Calendar | `NSCalendarsFullAccessUsageDescription` | `This app adds events to your calendar.` |
| Reminders | `NSRemindersFullAccessUsageDescription` | `This app creates reminders for your tasks.` |
| Speech Recognition | `NSSpeechRecognitionUsageDescription` | `This app transcribes spoken event titles.` |

Add `NSMicrophoneUsageDescription` as well when speech recognition captures
live audio. Localize these strings with the app target's `InfoPlist.strings`.
Do not add a generic or inaccurate value solely to silence App Store Connect;
remove the sensitive API from the final app instead when the feature is not
offered.

To add app-specific privacy information, use the `privacyContent` result
builder. Supply a single row, `Section`, or `Group`; custom content also makes
the Privacy destination available when the app has no detected permissions.

```swift
PreferenceKit(
    changeLog: nil,
    acknowledgements: nil,
    privacyContent: {
        Section("Privacy choices") {
            NavigationLink("Data controls") {
                Text("Choose how Example App uses your data.")
            }
        }
    }
)
```

## Next steps

For supported profile formats and the public configuration models, see
<doc:Configuration>.
