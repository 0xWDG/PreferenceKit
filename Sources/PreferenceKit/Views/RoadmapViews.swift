//
//  RoadmapViews.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-11-19.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// Shows all roadmap entries and provides navigation to their full details.
struct RoadmapListView: View {
    /// Entries fetched from the configured roadmap endpoint.
    let items: [RoadmapItem]

    /// Presents each entry as a selectable row in the navigation stack.
    var body: some View {
        List {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                NavigationLink {
                    RoadmapDetailView(item: item)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(item.title)
                                .font(.body)
                                .foregroundStyle(
                                    item.state.lowercased() == "open"
                                    ? .primary
                                    : .secondary
                                )
                                .fixedSize(horizontal: true, vertical: true)

                            Text("#\(item.id)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: true, vertical: true)
                        }

                        HStack(spacing: 1) {
                            Text("Last update:")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(
                                item.lastUpdated,
                                format: .dateTime.month(.abbreviated).day().year().hour().minute())
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Spacer()

                            let statusText = item.state.lowercased() == "open"
                            ? NSLocalizedString("Open", comment: "Open")
                            : NSLocalizedString("Closed", comment: "Closed")

                            Text("Status: \(statusText)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Feedback & Roadmap", bundle: .module))
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
}

/// Displays the description, metadata, and comments for one roadmap entry.
private struct RoadmapDetailView: View {
    /// The selected roadmap entry.
    let item: RoadmapItem

    /// Organizes the selected entry's content into readable detail sections.
    var body: some View {
        List {
            Section {
                Text(.init(item.description))
            }

            if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, *) {
                Section {
                    if !item.tags.isEmpty {
                        LabeledContent {
                            Text(item.tags.joined(separator: ", "))
                                .fixedSize(horizontal: false, vertical: true)
                        } label: {
                            Text("Tags", bundle: .module)
                        }
                    }

                    LabeledContent {
                        Text(item.openedDate, format: .dateTime.month(.abbreviated).day().year().hour().minute())
                    } label: {
                        Text("Opened", bundle: .module)
                    }
                    LabeledContent {
                        Text(item.lastUpdated, format: .dateTime.month(.abbreviated).day().year().hour().minute())
                    } label: {
                        Text("Updated", bundle: .module)
                    }
                } header: {
                    Text("Metadata", bundle: .module)
                }
            }

            if !item.comments.isEmpty {
                Section {
                    ForEach(Array(item.comments.enumerated()), id: \.offset) { _, comment in
                        Text(.init(comment))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                } header: {
                    Text("Comments", bundle: .module)
                }
            }
        }
        .navigation(
            title: "\(item.title) #\(item.id)",
            subtitle: item.state.lowercased() == "open"
            ? NSLocalizedString("Open", comment: "Open")
            : NSLocalizedString("Closed", comment: "Closed")
        )
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    NavigationStack {
        RoadmapListView(items: [
            .init(
                id: 1,
                title: "Test title",
                description: """
            # Markdown

            Rendered text

            I am **bold** text, i am *italic*, i am ~not~ there.
            """,
                comments: [],
                openedDate: .now.addingTimeInterval(-3600),
                lastUpdated: .now,
                tags: ["My", "Tag", "123"],
                state: "open"
            ),
            .init(
                id: 2,
                title: "Test title 2",
                description: """
            # Markdown

            Rendered text

            I am **bold** text, i am *italic*, i am ~not~ there.
            """,
                comments: [],
                openedDate: .now.addingTimeInterval(-3600),
                lastUpdated: .now,
                tags: ["My", "Tag", "123"],
                state: "closed"
            )
        ])
    }
}

@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    NavigationStack {
        RoadmapDetailView(
            item: .init(
                id: 1,
                title: "Test title",
                description: """
            # Markdown

            Rendered text

            I am **bold** text, i am *italic*, i am ~not~ there.
            """,
                comments: [],
                openedDate: .now.addingTimeInterval(-3600),
                lastUpdated: .now,
                tags: ["My", "Tag", "123"],
                state: "open"
            )
        )
    }
}
#endif
#endif
