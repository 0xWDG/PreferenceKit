//
//  AcknowledgementView.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2025-02-09.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// PreferenceKit Acknowledgement View
///
/// PreferenceKit Acknowledgement View is a SwiftUI View that can be used to show acknowledgements.
public struct PreferenceKitAcknowledgementView: View {
    /// The change log entries to display.
    public var entries: Set<Acknowledgement>
    private let displayedEntries: [Acknowledgement]

    /// The body of the view.
    public var body: some View {
        List {
            ForEach(displayedEntries) { entry in
                AcknowledgementRow(entry: entry)
            }
        }
        .navigationTitle(
            Text("Acknowledgements", bundle: Bundle.module)
        )
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }

    /// Initialize a new change log view.
    ///
    /// - Parameters:
    ///   - entries: The change log entries to display.
    public init(entries: [Acknowledgement]) {
        var entries = Set(entries)

        if entries.contains(
            where: { $0.name == "PreferenceKit" }
        ) == false {
            entries.insert(
                .init(
                    name: "PreferenceKit",
                    copyright: "Wesley de Groot",
                    licence: "MIT",
                    url: "https://github.com/0xWDG/PreferenceKit"
                )
            )
        }

        self.entries = entries
        var displayedNames = Set<String>()
        self.displayedEntries = entries
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
            .filter { displayedNames.insert($0.name).inserted }
    }
}

private struct AcknowledgementRow: View {
    let entry: Acknowledgement

    var body: some View {
        if let string = entry.url,
           let url = URL(string: string) {
#if canImport(WebKit) && (os(iOS) || os(macOS) || os(visionOS))
            NavigationLink {
                WebViewer(
                    url: url,
                    title: entry.name,
                    subtitle: entry.copyright
                )
            } label: {
                label
            }
#else
            browserButton(url: url)
#endif
        } else {
            label
        }
    }

    private var label: some View {
        VStack(alignment: .leading) {
            Text(entry.name)
            Text("Created by \(entry.copyright)", bundle: Bundle.module)
                .font(.callout)
            Text("Licensed under \(entry.licence)", bundle: Bundle.module)
                .font(.caption)
        }
        .accessibilityElement(children: .combine)
    }

    private func browserButton(url: URL) -> some View {
        Button {
            openURL(url)
        } label: {
            label
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    NavigationStack {
        PreferenceKitAcknowledgementView(entries: [
            .init(
                name: "Test",
                copyright: "Creator",
                licence: "MIT"
            )
        ])
    }
}
#endif
#endif
