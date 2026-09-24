//
//  PreferenceKitTests.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-09-24.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

import PreferenceKit
import Testing

@Suite("PreferenceKit public API")
struct PreferenceKitTests {
    @Test("Acknowledgements use their name as stable identity")
    func acknowledgementIdentity() {
        let acknowledgement = Acknowledgement(
            name: "Example Framework",
            copyright: "Example Author",
            licence: "MIT",
            url: "https://example.com"
        )

        #expect(acknowledgement.id == "Example Framework")
        #expect(acknowledgement.url == "https://example.com")
    }

    @Test("Changelog entries preserve their supplied metadata")
    func changeLogEntryMetadata() {
        let entry = ChangeLogEntry(
            version: "1.2.3",
            date: "2026-09-24",
            text: "Improved settings."
        )

        #expect(entry.id == "1.2.3")
        #expect(entry.date == "2026-09-24")
        #expect(entry.text == "Improved settings.")
    }

    @Test(
        "Social media profiles resolve to their service URLs",
        arguments: [
            (SocialMediaLink.Platform.github, "0xWDG", "https://github.com/0xWDG"),
            (.instagram, "@0xWDG", "https://www.instagram.com/0xWDG"),
            (.mastodon, "@0xWDG@mastodon.social", "https://mastodon.social/@0xWDG"),
            (.telegram, "@0xWDG", "https://t.me/0xWDG"),
            (.x, "@0xWDG", "https://x.com/0xWDG")
        ]
    )
    func socialMediaProfileURL(
        platform: SocialMediaLink.Platform,
        profile: String,
        expectedURL: String
    ) {
        let link = SocialMediaLink(platform: platform, profile: profile)

        #expect(link.url?.absoluteString == expectedURL)
    }

    @Test("Full HTTPS social-media URLs are preserved")
    func customSocialMediaURL() {
        let link = SocialMediaLink(
            platform: .discord,
            profile: "https://discord.gg/preferencekit"
        )

        #expect(link.url?.absoluteString == "https://discord.gg/preferencekit")
    }
}
