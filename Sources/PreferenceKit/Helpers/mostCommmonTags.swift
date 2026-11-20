//
//  openURL.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-11-20.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreferenceKit
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

@MainActor
/// Maps recognized roadmap tags to localization resources for display.
let mostCommmonTags: [String: LocalizedStringKey] = [
    "accessibility": "accessibility",
    "bug": "bug",
    "breaking change": "breaking change",
    "chore": "chore",
    "dependencies": "dependencies",
    "documentation": "documentation",
    "duplicate": "duplicate",
    "enhancement": "enhancement",
    "feature": "feature",
    "good first issue": "good first issue",
    "help wanted": "help wanted",
    "improvement": "improvement",
    "invalid": "invalid",
    "localization": "localization",
    "maintenance": "maintenance",
    "optional": "optional",
    "performance": "performance",
    "question": "question",
    "refactor": "refactor",
    "security": "security",
    "testing": "testing",
    "feedback": "Feedback",
    "wontfix": "wontfix",
    "user feedback": "user feedback"
]
#endif
