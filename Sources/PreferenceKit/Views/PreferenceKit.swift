//
//  PreferenceKit.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2025-02-09.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(SwiftUI)
import Foundation
import SwiftUI
#if canImport(OSLog)
import OSLogViewer
#endif
#if canImport(MessageUI)
import MessageUI
#endif

/// PreferenceKit Settings View
///
/// PreferenceKit Settings View is a SwiftUI View that can be used to show information about your app.
/// It can show the app icon, app name, created by, privacy policy, support email, twitter handle,
/// bluesky handle, mastodon handle, app store developer URL, changelog, and additional content.
public struct PreferenceKit<TopContent: View, BottomContent: View>: View {
#if canImport(MessageUI)
    @State
    private var result: Result<MFMailComposeResult, Error>?
#endif

    @State
    private var isShowingMailView = false

#if canImport(OSLog)
    private var extractor: OSLogExtractor?
#endif

    @State
    private var OSLogString = ""

    @State
    private var isLoading: Bool = false

    @State
    private var reviewURL: URL?

    @State
    private var developerURL: URL?

    @State
    private var updateAvailable: Bool = false

    @State
    private var appStoreVersion: String = ""

    // MARK: Custom
    let createdBy: String?
    let privacyPolicyURL: URL?
    let supportEmail: String?
    let socialMediaLinks: [SocialMediaLink]
    let changeLog: [ChangeLogEntry]?
    let acknowledgments: [Acknowledgement]?
    let customTopSection: TopContent?
    let customBottomSection: BottomContent?

    /// Initialize PreferenceKit Settings View
    ///
    /// PreferenceKit Settings View is a SwiftUI View that can be used to show information about your app.
    /// It can show the app icon, app name, created by, privacy policy, support email, twitter handle,
    /// bluesky handle, mastodon handle, app store developer URL, changelog, and additional content.
    ///
    /// - Parameters:
    ///   - createdBy: Your name (supports markdown)
    ///   - privacyPolicyURL: Privacy policy URL.
    ///   - supportEmail: Your support email
    ///   - socialMediaLinks: Additional social media profile links to display.
    ///   - OSLogSubsystem: The subsystem for your OS-Logs (nil = hidden), no value = AppBundle
    ///   - changeLog: Changelog
    ///   - acknowledgements: Acknowledgements to mention
    ///   - topContent: Custom top content
    ///   - bottomContent: Custom bottom content
    public init(
        createdBy: String? = nil,
        privacyPolicyURL: URL? = nil,
        supportEmail: String? = nil,
        socialMediaLinks: [SocialMediaLink] = [],
        OSLogSubsystem: String? = Bundle.main.bundleIdentifier,
        changeLog: [ChangeLogEntry]?,
        acknowledgements: [Acknowledgement]?,
        @ViewBuilder topContent: @escaping () -> TopContent? = {
            EmptyView()
        },
        @ViewBuilder bottomContent: @escaping () -> BottomContent? = {
            EmptyView()
        }
    ) {
        self.createdBy = createdBy
        self.privacyPolicyURL = privacyPolicyURL
        self.supportEmail = supportEmail
        self.socialMediaLinks = socialMediaLinks
        self.changeLog = changeLog
        self.acknowledgments = acknowledgements
        self.customTopSection = topContent()
        self.customBottomSection = bottomContent()
#if canImport(OSLog)
        if let OSLogSubsystem {
            self.extractor = OSLogExtractor(
                subsystem: OSLogSubsystem,
                since: Date().addingTimeInterval(-900) // 15 minutes max.
            )
        }
#endif
    }

    /// Internal: Initializes PreferenceKit Settings View (with default parameters for my apps)
    public init(
        _changeLog: [ChangeLogEntry]?,
        // swiftlint:disable:previous identifier_name
        _acknowledgements: [Acknowledgement]?,
        // swiftlint:disable:previous identifier_name
        @ViewBuilder topContent: @escaping () -> TopContent? = { EmptyView() },
        @ViewBuilder bottomContent: @escaping () -> BottomContent? = { EmptyView() }
    ) {
        self.createdBy = "[Wesley de Groot](https://wesleydegroot.nl)"
        self.privacyPolicyURL = URL(
            string: "https://wesleydegroot.nl/apps/\(PKAppInfo.appName.slugified)/privacy/"
        )
        self.supportEmail = "email+\(PKAppInfo.appName.slugified)@wesleydegroot.nl"
        self.socialMediaLinks = [
            .init(platform: .x, profile: "0xWDG"),
            .init(platform: .bluesky, profile: "0xwdg.bsky.social"),
            .init(platform: .mastodon, profile: "@0xWDG@mastodon.social"),
            .init(platform: .website, profile: "https://wesleydegroot.nl")
        ]
        self.developerURL = URL(string: "https://apps.apple.com/developer/id602359900")
        self.changeLog = _changeLog
        self.acknowledgments = _acknowledgements
        self.customTopSection = topContent()
        self.customBottomSection = bottomContent()
#if canImport(OSLog)
        self.extractor = OSLogExtractor(
            subsystem: "nl.wesleydegroot",
            since: Date().addingTimeInterval(-900) // 15 minutes max.
        )
#endif
    }

    var getMailBody: String {
        return """
        Hello,\n
        I want to give some feedback/report a bug in \(PKAppInfo.appName),\n
        ....\n
        - PLEASE DO NOT CHANGE ANYTHING BELOW THIS LINE -\n\n
        Version: \(PKAppInfo.versionNumber), \
        Build: \(PKAppInfo.buildNumber), \
        Environment: \(PKAppInfo.isTestflight ? "TestFlight" : "AppStore"), \
        Model: \(PKAppInfo.modelName) \
        iOSAppOnMac: \(PKAppInfo.isiOSAppOnMac ? "Yes" : "No").\n
        Log (Please do not change):\n\(OSLogString)
        """
    }

    /// The application settings and support information.
    public var body: some View {
        Group {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                NavigationStack {
                    settingsForm
                        .formStyle(.grouped)
                }
            } else {
                NavigationView {
                    settingsForm
                }
#if os(iOS)
                .navigationViewStyle(.stack)
#endif
            }
        }
    }

    private var settingsForm: some View {
        Form {
            PreferenceKitHeaderSection(createdBy: createdBy)
            PreferenceKitUpdateSection(
                updateAvailable: updateAvailable,
                appStoreVersion: appStoreVersion
            )
            customTopSection // Custom section
            PreferenceKitApplicationInfoSection(
                changeLog: changeLog,
                acknowledgments: acknowledgments,
                privacyPolicyURL: privacyPolicyURL,
                supportEmail: supportEmail,
                fetchLogs: {
#if canImport(OSLogViewer) && canImport(OSLog)
                    if let extractor {
                        return await extractor.export()
                    }
#endif
                    return ""
                },
                reviewURL: $reviewURL,
                logString: $OSLogString,
                isLoading: $isLoading,
                isShowingMailView: $isShowingMailView
            )
            PreferenceKitDeveloperSection(
                socialMediaLinks: socialMediaLinks,
                developerURL: $developerURL
            )
            customBottomSection
            PreferenceKitFooterSection()
        }
        .task {
            updateAvailable = await PKAppInfo.updateAvailable
            appStoreVersion = await PKAppInfo.appStoreVersion
        }
        .buttonStyle(.list)
        .foregroundStyle(Color.primary)
        .navigationTitle(PKAppInfo.appName)
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
#if canImport(SwiftUI) && canImport(MessageUI)
        .sheet(isPresented: $isShowingMailView) {
            if let supportEmail = self.supportEmail {
                MailView(result: $result) { composer in
                    composer.setSubject("\(PKAppInfo.appName.slugified) Feedback")
                    composer.setToRecipients([supportEmail])
                    composer.setMessageBody(getMailBody, isHTML: false)
                }
            }
        }
#endif
    }

}

#if DEBUG
private struct PKSettingsDemo: View {
    @Binding var isPresented: Bool

    var body: some View {
        PreferenceKit(
            _changeLog: [
                .init(
                    version: "0.0.1",
                    date: "\(Date.now.ddmmyyyy)",
                    text: "Initial version"
                )
            ],
            _acknowledgements: [
                .init(
                    name: "This Package",
                    copyright: "Wesley de Groot",
                    licence: "Licence",
                    url: "https://wesleydegroot.nl"
                )
            ],
            topContent: {
                Toggle("Open Sheet", isOn: $isPresented)
            }
        )
    }
}

@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    @Previewable @State var isPresented: Bool = false

    PKSettingsDemo(isPresented: $isPresented)
        .sheet(isPresented: $isPresented) {
            PKSettingsDemo(isPresented: $isPresented)
        }
}
#endif
#endif
