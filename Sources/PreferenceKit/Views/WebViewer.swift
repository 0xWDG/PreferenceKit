//
//  WebViewer.swift
//  PreferenceKit
//
//  Created by Wesley de Groot on 24/09/2026.
//

#if canImport(SwiftUI)
import SwiftUI

struct WebViewer: View {
    let url: URL
    let title: String
    let subtitle: String?

    init(url: URL, title: String, subtitle: String? = nil) {
        self.url = url
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        if #available(iOS 26.0, macOS 26.0, visionOS 26.0, *), let subtitle {
            ZStack {
                Color
                    .listBackground
                    .ignoresSafeArea()

                WebView(url: url)
                    .navigationTitle(title)
                    .navigationSubtitle(subtitle)
                    .toolbar {
                        Button {
                            openURL(url)
                        } label: {
                            Image(systemName: "safari")
                                .accessibilityLabel(Text("Open in web browser"))
                        }
                    }
            }
        } else {
            ZStack {
                Color
                    .listBackground
                    .ignoresSafeArea()

                WebView(url: url)
                    .navigationTitle(title)
                    .toolbar {
                        Button {
                            openURL(url)
                        } label: {
                            Image(systemName: "safari")
                                .accessibilityLabel(Text("Open in web browser"))
                        }
                    }
            }
        }
    }
}
#endif
