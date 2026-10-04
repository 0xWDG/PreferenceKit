//
//  PreferenceKitPrivacyViews.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-10-04.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

#if os(iOS) || targetEnvironment(macCatalyst)
import UIKit
#endif

/// Lists the privacy capabilities that the host application declares.
struct PreferenceKitPrivacyList: View {
    /// The permissions available to inspect.
    let permissions: [PreferenceKitPrivacyPermission]

    /// Optional app-specific rows or sections.
    let customContent: AnyView?

    var body: some View {
        List {
            if let customContent {
                customContent
            }

            if !permissions.isEmpty {
                Section {
                    ForEach(permissions) { permission in
                        NavigationLink {
                            PreferenceKitPrivacyDetail(
                                permission: permission
                            )
                        } label: {
                            Label {
                                Text(permission.name, bundle: .module)
                            } icon: {
                                PreferenceKitPrivacyIcon(
                                    permission: permission,
                                    size: 24
                                )
                            }
                        }
                    }
                } header: {
                    Text("Privacy permissions", bundle: .module)
                }
            }
        }
        .navigationTitle(Text("Privacy", bundle: .module))
    }
}

/// Explains one declared privacy capability and links to its system setting.
private struct PreferenceKitPrivacyDetail: View {
    /// The capability being explained.
    let permission: PreferenceKitPrivacyPermission

    /// The reason the host application gives for accessing the capability.
    let usageDescription: String

    /// Opens the platform-specific Settings destination.
    @Environment(\.openURL) private var openURL

    /// The current authorization state, fetched without requesting access.
    @State private var authorizationStatus: PreferenceKitPrivacyAuthorizationStatus = .notDetermined

    /// Creates a focused privacy explanation for one capability.
    ///
    /// - Parameters:
    ///   - permission: The capability whose privacy details are displayed.
    ///   - usageDescription: An optional preview-specific replacement for the
    ///     host app's declared reason.
    init(
        permission: PreferenceKitPrivacyPermission,
        usageDescription: String? = nil
    ) {
        self.permission = permission
        self.usageDescription = usageDescription ?? permission.usageDescription
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                privacyCard

                if let settingsURL {
                    Button {
                        openURL(settingsURL)
                    } label: {
                        Label("Open Settings", systemImage: "arrow.up.forward")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 20)
                            .background(.background, in: Capsule())
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.tint)
                    .accessibilityLabel(Text("Open Settings", bundle: .module))
                    .accessibilityHint(Text("Changes this permission in the system Settings app", bundle: .module))
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 24)
        }
        .background(Color.primary.opacity(0.045).ignoresSafeArea())
        .navigationTitle(Text(permission.name, bundle: .module))
        .task(id: permission) {
            authorizationStatus = await permission.authorizationStatusProvider()
        }
    }

    /// The elevated card containing the capability's privacy explanation.
    private var privacyCard: some View {
        VStack(spacing: 20) {
            PreferenceKitPrivacyIcon(permission: permission, size: 136)
                .frame(width: 136, height: 136)

            Text(permission.name, bundle: .module)
                .font(.title.bold())

            Text(usageDescription)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            HStack {
                Text("Permission Status", bundle: .module)
                Spacer(minLength: 12)
                Text(authorizationStatus.displayName, bundle: .module)
                    .foregroundStyle(authorizationStatus.tint)
                    .multilineTextAlignment(.trailing)
            }
            .font(.body.weight(.medium))
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(.background, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    /// The settings page used to change the capability's authorization.
    private var settingsURL: URL? {
#if os(iOS) || targetEnvironment(macCatalyst)
        if permission == .notifications,
           #available(iOS 16.0, *) {
            return URL(string: UIApplication.openNotificationSettingsURLString)
        }
        return URL(string: UIApplication.openSettingsURLString)
#elseif os(macOS)
        return URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy")
#else
        nil
#endif
    }
}

/// Renders a privacy symbol in an app-icon-shaped colored tile.
private struct PreferenceKitPrivacyIcon: View {
    /// The permission represented by the icon.
    let permission: PreferenceKitPrivacyPermission

    /// The square display dimension in points.
    let size: CGFloat

    /// The proportional corner radius that matches the familiar app icon silhouette.
    private var cornerRadius: CGFloat { size * 0.225 }

    /// The symbol color that preserves contrast against the tile background.
    private var foregroundColor: Color {
        permission.id == "reminders" ? .black : .white
    }

    var body: some View {
        Image(systemName: permission.symbolName)
            .font(.system(size: size * 0.38, weight: .medium))
            .foregroundStyle(foregroundColor)
        .frame(width: size, height: size)
        .background(
            permission.backgroundColor,
            in: RoundedRectangle(
                cornerRadius: cornerRadius,
                style: .continuous
            )
        )
        .overlay {
        if permission.id == "reminders" {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.gray.opacity(0.25), lineWidth: 1)
            }
        }
        .accessibilityHidden(true)
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("Privacy") {
    NavigationStack {
        PreferenceKitPrivacyList(
            permissions: [],
            customContent: nil
        )
    }
}

@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("Microphone Privacy") {
    NavigationStack {
        PreferenceKitPrivacyDetail(
            permission: .init(
                id: "preview",
                name: "Microphone",
                symbolName: "mic.fill",
                backgroundColor: .orange,
                usageDescriptionKeys: [],
                previewUsageDescription: "Microphone access lets Example App record audio for voice notes.",
                authorizationStatus: { .notDetermined }
            ),
            usageDescription: "Microphone access lets Example App record audio for voice notes."
        )
        .environment(\.locale, .init(identifier: "nl-NL"))
    }
}
#endif
#endif
