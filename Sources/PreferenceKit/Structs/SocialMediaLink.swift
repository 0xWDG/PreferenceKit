//
//  SocialMediaLink.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-09-24.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

import Foundation

/// A link to a social media profile displayed in `PreferenceKit`.
public struct SocialMediaLink: Identifiable, Hashable {
    /// A supported social media service with a matching bundled symbol asset.
    public enum Platform: String, CaseIterable, Hashable, Identifiable, Sendable {
        case bluesky
        case discord
        case facebook
        case github
        case instagram
        case linkedin
        case mastodon
        case matrix
        case microblog
        case reddit
        case slack
        case telegram
        case threads
        case tiktok
        case twitch
        // swiftlint:disable:next identifier_name
        case x
        case youtube
        case website

        /// A stable identifier for the platform.
        public var id: String { rawValue }

        /// The user-facing name of the platform.
        public var displayName: String {
            switch self {
            case .bluesky: "Bluesky"
            case .discord: "Discord"
            case .facebook: "Facebook"
            case .github: "GitHub"
            case .instagram: "Instagram"
            case .linkedin: "LinkedIn"
            case .mastodon: "Mastodon"
            case .matrix: "Matrix"
            case .microblog: "Micro.blog"
            case .reddit: "Reddit"
            case .slack: "Slack"
            case .telegram: "Telegram"
            case .threads: "Threads"
            case .tiktok: "TikTok"
            case .twitch: "Twitch"
            case .x: "𝕏/Twitter"
            case .youtube: "YouTube"
            case .website: "Website"
            }
        }

        /// The name of the matching bundled symbol asset, when one exists.
        var assetName: String? {
            switch self {
            case .website: nil
            default: rawValue
            }
        }
    }
    /// The social media service associated with the link.
    public let platform: Platform

    /// The account handle, user identifier, workspace, or full HTTPS URL.
    public let profile: String

    /// A stable identifier for the link.
    public var id: String {
        "\(platform.rawValue)-\(profile)"
    }

    /// The profile or community URL to open.
    ///
    /// Supply a full HTTPS URL in `profile` for services with a custom profile
    /// route, such as a Discord invite or Slack workspace member URL.
    public var url: URL? {
        let trimmedProfile = profile.trimmingCharacters(in: .whitespacesAndNewlines)

        if let url = URL(string: trimmedProfile),
           let scheme = url.scheme?.lowercased(),
           ["http", "https"].contains(scheme) {
            return url
        }

        switch platform {
        case .bluesky:
            return profileURL("https://bsky.app/profile/\(trimmedProfile)")
        case .discord:
            return profileURL("https://discord.com/users/\(trimmedProfile)")
        case .facebook:
            return profileURL("https://www.facebook.com/\(trimmedProfile)")
        case .github:
            return profileURL("https://github.com/\(trimmedProfile)")
        case .instagram:
            return profileURL("https://www.instagram.com/\(removingPrefix("@", from: trimmedProfile))")
        case .linkedin:
            return profileURL("https://www.linkedin.com/in/\(trimmedProfile)")
        case .mastodon:
            return mastodonURL(for: trimmedProfile)
        case .matrix:
            return profileURL("https://matrix.to/#/\(trimmedProfile)")
        case .microblog:
            return profileURL("https://micro.blog/\(trimmedProfile)")
        case .reddit:
            return profileURL("https://www.reddit.com/user/\(removingPrefix("u/", from: trimmedProfile))")
        case .slack:
            return profileURL("https://\(trimmedProfile).slack.com")
        case .telegram:
            return profileURL("https://t.me/\(removingPrefix("@", from: trimmedProfile))")
        case .threads:
            return profileURL("https://www.threads.com/@\(removingPrefix("@", from: trimmedProfile))")
        case .tiktok:
            return profileURL("https://www.tiktok.com/@\(removingPrefix("@", from: trimmedProfile))")
        case .twitch:
            return profileURL("https://www.twitch.tv/\(trimmedProfile)")
        case .x:
            return profileURL("https://x.com/\(removingPrefix("@", from: trimmedProfile))")
        case .youtube:
            return profileURL("https://www.youtube.com/@\(removingPrefix("@", from: trimmedProfile))")
        case .website:
            return URL(string: profile)
        }
    }

    private func mastodonURL(for profile: String) -> URL? {
        let handle = removingPrefix("@", from: profile)
        let components = handle.split(separator: "@", maxSplits: 1)

        guard let username = components.first, !username.isEmpty else {
            return nil
        }

        let host = components.count == 2 ? String(components[1]) : "mastodon.social"
        return profileURL("https://\(host)/@\(username)")
    }

    private func profileURL(_ value: String) -> URL? {
        URL(string: value.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? value)
    }

    private func removingPrefix(_ prefix: String, from value: String) -> String {
        value.hasPrefix(prefix) ? String(value.dropFirst(prefix.count)) : value
    }

    /// Creates a social media link.
    ///
    /// - Parameters:
    ///   - platform: The social media service represented by the link.
    ///   - profile: The account handle, user identifier, workspace, or full HTTPS URL.
    public init(platform: Platform, profile: String) {
        self.platform = platform
        self.profile = profile
    }
}
