# PreferenceKit

PreferenceKit is a Swift Package for ...

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FPreferenceKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/0xWDG/PreferenceKit)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FPreferenceKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/0xWDG/PreferenceKit)

[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)

![License](https://img.shields.io/github/license/0xWDG/PreferenceKit)

## Requirements

- Swift 6.0+ (Xcode 16+)
- iOS 16+, macOS 13+, watchOS 9+, tvOS 16+

## Installation (Package.swift)

```swift
dependencies: [
    .package(url: "https://github.com/0xWDG/PreferenceKit.git", branch: "main"),
],
targets: [
    .target(name: "MyTarget", dependencies: [
        .product(name: "PreferenceKit", package: "PreferenceKit"),
    ]),
]
```

## Installation (Xcode)

1. In Xcode, open your project and navigate to **File > Swift Packages > Add Package Dependency...**
2. Paste the repository URL (`https://github.com/0xWDG/PreferenceKit`) and click **Next**.
3. Click **Finish**.

## Usage

```swift
import SwiftUI
import PreferenceKit

struct ContentView: View {
    var body: some View {
        VStack {
            /// ...
        }
        .padding()
    }
}
```

## Contact

[https://wesleydegroot.nl](https://wesleydegroot.nl)

Interested learning more about Swift? [Check out my blog](https://wesleydegroot.nl/blog/).