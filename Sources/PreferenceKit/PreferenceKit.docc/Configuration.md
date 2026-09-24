# Configuration reference

@Metadata {
    @PageKind(article)
}

Configure ``PreferenceKit`` with the public models in this package.

## Changelog entries

Use ``ChangeLogEntry`` for each release you want to show. A version is the
entry's identity, so use a unique version value for every entry. Supply a date
when it is useful to your users.

```swift
let changeLog: [ChangeLogEntry] = [
    .init(version: "2.0", date: "2026-09-24", text: "Added account sharing."),
    .init(version: "1.0", text: "Initial release.")
]
```

## Acknowledgements

Use ``Acknowledgement`` to credit dependencies, artwork, or other contributors.
The name is the acknowledgement identity. PreferenceKit automatically includes
its own acknowledgement and displays a linked row when `url` is valid.

```swift
let acknowledgements: [Acknowledgement] = [
    .init(
        name: "Example Dependency",
        copyright: "Example Authors",
        licence: "MIT",
        url: "https://github.com/example/dependency"
    )
]
```

## Social-media links

Create a ``SocialMediaLink`` with a ``SocialMediaLink/Platform`` and a profile
identifier. PreferenceKit derives the destination URL and shows the matching
bundled symbol where one exists.

| Platform | Profile value |
| --- | --- |
| Bluesky | `example.bsky.social` |
| Discord | User ID, or a complete invite URL |
| Facebook | Profile name |
| GitHub | Account name |
| Instagram | Account name, with or without `@` |
| LinkedIn | Profile name |
| Mastodon | `@name@server.example` or `name` for `mastodon.social` |
| Matrix | Matrix identifier |
| Micro.blog | Account name |
| Reddit | Account name, with or without `u/` |
| Slack | Workspace subdomain, or a complete member URL |
| Telegram | Account name, with or without `@` |
| Threads | Account name, with or without `@` |
| TikTok | Account name, with or without `@` |
| Twitch | Account name |
| X | Account name, with or without `@` |
| YouTube | Channel handle, with or without `@` |
| Website | Complete HTTP or HTTPS URL |

```swift
let profiles: [SocialMediaLink] = [
    .init(platform: .github, profile: "example"),
    .init(platform: .mastodon, profile: "@example@mastodon.social"),
    .init(platform: .discord, profile: "https://discord.gg/example")
]
```

Any complete HTTP or HTTPS URL is preserved without transformation. This lets
you use a custom profile route, an invitation, or a workspace-specific link.
