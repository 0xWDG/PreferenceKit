//
//  PreferenceKitApplicationInfoSection.swift
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
#if canImport(MessageUI)
import MessageUI
#endif

struct PreferenceKitApplicationInfoSection: View {
    let changeLog: [ChangeLogEntry]?
    let acknowledgments: [Acknowledgement]?
    let privacyPolicyURL: URL?
    let supportEmail: String?
    let fetchLogs: () async -> String
    @Binding private var reviewURL: URL?
    @Binding private var logString: String
    @Binding private var isLoading: Bool
    @Binding private var isShowingMailView: Bool

    init(
        changeLog: [ChangeLogEntry]?,
        acknowledgments: [Acknowledgement]?,
        privacyPolicyURL: URL?,
        supportEmail: String?,
        fetchLogs: @escaping () async -> String,
        reviewURL: Binding<URL?>,
        logString: Binding<String>,
        isLoading: Binding<Bool>,
        isShowingMailView: Binding<Bool>
    ) {
        self.changeLog = changeLog
        self.acknowledgments = acknowledgments
        self.privacyPolicyURL = privacyPolicyURL
        self.supportEmail = supportEmail
        self.fetchLogs = fetchLogs
        _reviewURL = reviewURL
        _logString = logString
        _isLoading = isLoading
        _isShowingMailView = isShowingMailView
    }

    var body: some View {
        Section {
            if let changeLog {
                NavigationLink(destination: PreferenceKitChangeLogView(changeLog: changeLog)) {
                    Label {
                        Text("Changelog", bundle: Bundle.module)
                    } icon: {
                        Image(systemName: "newspaper")
                            .accessibilityHidden(true)
                    }
                }
            }

            if let acknowledgments {
                NavigationLink(destination: PreferenceKitAcknowledgementView(entries: acknowledgments)) {
                    Label {
                        Text("Acknowledgements", bundle: Bundle.module)
                    } icon: {
                        Image(systemName: "hands.clap")
                            .accessibilityHidden(true)
                    }
                }
            }

            if let privacyPolicyURL {
                PrivacyPolicyLink(url: privacyPolicyURL)
            }

            if let reviewURL {
                Button {
                    openURL(reviewURL)
                } label: {
                    Label {
                        Text("Rate the app", bundle: Bundle.module)
                    } icon: {
                        Image(systemName: "star")
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            if let supportEmail {
                Button {
                    Task {
                        await sendFeedback(to: supportEmail)
                    }
                } label: {
                    HStack {
                        Label {
                            Text("Feedback", bundle: Bundle.module)
                        } icon: {
                            Image(systemName: "pencil.and.ellipsis.rectangle")
                                .accessibilityHidden(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        if isLoading {
                            ProgressView()
#if !os(tvOS)
                                .controlSize(.small)
#endif
                            Text("Fetching logs", bundle: Bundle.module)
                                .lineLimit(1)
                                .allowsTightening(true)
                                .minimumScaleFactor(0.3)
                        }
                    }
                }
                .disabled(isLoading)
            }
        } header: {
            Label {
                Text("Application Info", bundle: Bundle.module)
            } icon: {
                Image(systemName: "info.circle")
                    .accessibilityHidden(true)
            }
        }
        .task {
            if reviewURL == nil {
                reviewURL = await PKAppInfo.reviewURL
            }
        }
    }

    private func sendFeedback(to supportEmail: String) async {
        isLoading = true
        logString = await fetchLogs()
        isLoading = false

#if canImport(MessageUI)
        if MFMailComposeViewController.canSendMail() {
            isShowingMailView = true
            return
        }
#endif

        var components = URLComponents()
        components.scheme = "mailto"
        components.path = supportEmail
        components.queryItems = [
            URLQueryItem(name: "subject", value: "\(PKAppInfo.appName) Feedback"),
            URLQueryItem(name: "body", value: mailBody)
        ]
        openURL(components.url)
    }

    private var mailBody: String {
        """
        Hello,

        I want to give some feedback/report a bug in \(PKAppInfo.appName),
        ....

        - PLEASE DO NOT CHANGE ANYTHING BELOW THIS LINE -

        Version: \(PKAppInfo.versionNumber)
        Build: \(PKAppInfo.buildNumber)
        Environment: \(PKAppInfo.isTestflight ? "TestFlight" : "AppStore")
        Model: \(PKAppInfo.modelName)
        iOSAppOnMac: \(PKAppInfo.isiOSAppOnMac ? "Yes" : "No").
        Log (Please do not change):
        \(logString)
        """
    }
}

private struct PrivacyPolicyLink: View {
    let url: URL

    var body: some View {
#if canImport(WebKit) && (os(iOS) || os(macOS) || os(visionOS))
        if #available(iOS 26.0, macOS 26.0, visionOS 26.0, *) {
            NavigationLink {
                WebViewer(url: url, title: "Privacy Policy")
            } label: {
                label
            }
        } else {
            browserButton
        }
#else
        browserButton
#endif
    }

    private var browserButton: some View {
        Button {
            openURL(url)
        } label: {
            label
        }
    }

    private var label: some View {
        Label {
            Text("Privacy Policy", bundle: Bundle.module)
        } icon: {
            Image(systemName: "person.badge.key")
                .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    NavigationStack {
        Form {
            PreferenceKitApplicationInfoSection(
                changeLog: [.init(version: "1.0", text: "Initial release")],
                acknowledgments: [
                    .init(
                        name: "PreferenceKit",
                        copyright: "PreferenceKit",
                        licence: "MIT",
                        url: "https://github.com/0xWDG/PreferenceKit")
                ],
                privacyPolicyURL: URL(
                    string: "https://wesleydegroot.nl/privacy"
                ),
                supportEmail: "email@wesleydegroot.nl",
                fetchLogs: { "Preview log" },
                reviewURL: .constant(URL(
                    string: "https://wesleydegroot.nl/review"
                )),
                logString: .constant("Preview log"),
                isLoading: .constant(false),
                isShowingMailView: .constant(false)
            )
        }
    }
}
#endif
#endif
