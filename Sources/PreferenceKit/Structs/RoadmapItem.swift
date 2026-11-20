//
//  RoadmapItem.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 2026-11-19.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

import Foundation

/// RoadmapItem represents an item in a tracking system with details such as title, description, \
/// comments, dates, tags, and state.
///
/// This struct conforms to Codable and Identifiable protocols, \
/// making it suitable for encoding/decoding and unique identification within collections.
public struct RoadmapItem: Codable, Identifiable {
    /// The unique identifier for the roadmap item.
    public let id: Int

    /// The title of the roadmap item.
    public let title: String

    /// The description of the roadmap item.
    public let description: String

    /// The comments associated with the roadmap item.
    public let comments: [String]

    /// The date when the roadmap item was opened.
    public let openedDate: Date

    /// The date when the roadmap item was last updated.
    public let lastUpdated: Date

    /// The tags associated with the roadmap item.
    public let tags: [String]

    /// The current state of the roadmap item.
    public let state: String
}
