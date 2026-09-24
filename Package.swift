// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

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
        )
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
            resources: [
                .process("Assets.xcassets"),
                .process("Localizable.xcstrings")
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        ),
        .testTarget(
            name: "PreferenceKitTests",
            dependencies: ["PreferenceKit"]
        )
    ]
)
