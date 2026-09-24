//
//  ChangeLogView.swift
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

/// PreferenceKit Change Log View
///
/// PreferenceKit Change Log View is a SwiftUI View that can be used to show a change log.
public struct PreferenceKitChangeLogView: View {
    /// The change log entries to display.
    var changeLog: [ChangeLogEntry]

    /// The list of change-log entries.
    public var body: some View {
        List {
            ForEach(changeLog) { changeLogEntry in
                Section {
                    Text(.init(changeLogEntry.text))
                } header: {
                    HStack {
                        Group {
                            Text("Version", bundle: Bundle.module) +
                            Text(" ") +
                            Text(.init(changeLogEntry.version))
                        }
                        .lineLimit(1)

                        if let date = changeLogEntry.date {
                            Spacer()

                            Text(date)
                                .lineLimit(1)
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Changelog", bundle: Bundle.module))
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }

    /// Initialize a new change log view.
    ///
    /// - Parameters:
    ///   - changeLog: The change log entries to display.
    public init(changeLog: [ChangeLogEntry]) {
        self.changeLog = changeLog
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    NavigationStack {
        PreferenceKitChangeLogView(changeLog: [
            .init(
                version: "1.0.0",
                date: "13-08-2026",
                text: "Initial version"
            )
        ])
    }
}
#endif
#endif
