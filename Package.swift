// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(Linux)
let preferenceKitResources: [Resource] = []
let preferenceKitExcludedResources = [
    "Assets.xcassets",
    "Localizable.xcstrings"
]
#else
let preferenceKitResources: [Resource] = [
    .process("Assets.xcassets"),
    .process("Localizable.xcstrings")
]
let preferenceKitExcludedResources: [String] = []
#endif

let package = Package(
    name: "PreferenceKit",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PreferenceKit",
            targets: ["PreferenceKit"]
        ),
        .library(name: "PreferenceKitCamera", targets: ["PreferenceKitCamera"]),
        .library(name: "PreferenceKitMicrophone", targets: ["PreferenceKitMicrophone"]),
        .library(name: "PreferenceKitPhotos", targets: ["PreferenceKitPhotos"]),
        .library(name: "PreferenceKitLocation", targets: ["PreferenceKitLocation"]),
        .library(name: "PreferenceKitContacts", targets: ["PreferenceKitContacts"]),
        .library(name: "PreferenceKitCalendar", targets: ["PreferenceKitCalendar"]),
        .library(name: "PreferenceKitReminders", targets: ["PreferenceKitReminders"]),
        .library(name: "PreferenceKitSpeechRecognition", targets: ["PreferenceKitSpeechRecognition"]),
        .library(name: "PreferenceKitNotifications", targets: ["PreferenceKitNotifications"])
    ],
    dependencies: [
        .package(url: "https://github.com/0xWDG/OSLogViewer.git", from: "1.1.6")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PreferenceKit",
            dependencies: [
                .product(name: "OSLogViewer", package: "OSLogViewer")
            ],
            exclude: preferenceKitExcludedResources,
            resources: preferenceKitResources,
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        ),
        .target(name: "PreferenceKitCamera", dependencies: ["PreferenceKit"]),
        .target(name: "PreferenceKitMicrophone", dependencies: ["PreferenceKit"]),
        .target(name: "PreferenceKitPhotos", dependencies: ["PreferenceKit"]),
        .target(name: "PreferenceKitLocation", dependencies: ["PreferenceKit"]),
        .target(name: "PreferenceKitContacts", dependencies: ["PreferenceKit"]),
        .target(name: "PreferenceKitCalendar", dependencies: ["PreferenceKit"]),
        .target(name: "PreferenceKitReminders", dependencies: ["PreferenceKit"]),
        .target(name: "PreferenceKitSpeechRecognition", dependencies: ["PreferenceKit"]),
        .target(name: "PreferenceKitNotifications", dependencies: ["PreferenceKit"]),
        .testTarget(
            name: "PreferenceKitTests",
            dependencies: ["PreferenceKit"]
        )
    ]
)
