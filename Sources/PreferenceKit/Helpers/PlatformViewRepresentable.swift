//
//  PlatformViewRepresentable.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-14.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if !os(watchOS) && canImport(SwiftUI)
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// A platform-agnostic version of `UIViewRepresentable`/`NSViewRepresentable`,
/// allowing for a single implementation to be used for both UIKit and AppKit platforms.
protocol PlatformViewRepresentable: PlatformViewRepresentableType {
    /// The type of view this representable manages.
    associatedtype PlatformViewType

    /// Create the platform view.
    ///
    /// - Parameter context: SwiftUI context.
    /// - Returns: The new instance of your platform view.
    ///
    /// This is equivalent to `makeUIView` on UIKit platforms and `makeNSView` on AppKit platforms.
    func makePlatformView(context: Context) -> PlatformViewType

    /// Update the platform view.
    ///
    /// - Parameters:
    ///   - platformView: The platform view instance.
    ///   - context: SwiftUI context.
    ///
    /// This is equivalent to `updateUIView` on UIKit platforms and `updateNSView` on AppKit platforms.
    func updatePlatformView(_ platformView: PlatformViewType, context: Context)
}

#if canImport(UIKit)
/// A platform-agnostic version of `UIViewRepresentable`/`NSViewRepresentable`,
/// allowing for a single implementation to be used for both UIKit and AppKit platforms.
extension PlatformViewRepresentable where UIViewType == PlatformViewType {
    /// Create the platform view.
    ///
    /// - Parameter context: SwiftUI context.
    /// - Returns: The new instance of your platform view.
    ///
    /// This is equivalent to `makeUIView` on UIKit platforms and `makeNSView` on AppKit platforms.
    func makeUIView(context: Context) -> UIViewType {
        makePlatformView(context: context)
    }

    /// Update the platform view.
    ///
    /// - Parameters:
    ///   - uiView: The platform view instance.
    ///   - context: SwiftUI context.
    ///
    /// This is equivalent to `updateUIView` on UIKit platforms and `updateNSView` on AppKit platforms.
    func updateUIView(_ uiView: UIViewType, context: Context) {
        updatePlatformView(uiView, context: context)
    }
}
#else
extension PlatformViewRepresentable where NSViewType == PlatformViewType {
    /// Create the platform view.
    ///
    /// - Parameter context: SwiftUI context.
    /// - Returns: The new instance of your platform view.
    ///
    /// This is equivalent to `makeUIView` on UIKit platforms and `makeNSView` on AppKit platforms.
    func makeNSView(context: Context) -> NSViewType {
        makePlatformView(context: context)
    }

    /// Update the platform view.
    ///
    /// - Parameters:
    ///   - nsView: The platform view instance.
    ///   - context: SwiftUI context.
    ///
    /// This is equivalent to `updateUIView` on UIKit platforms and `updateNSView` on AppKit platforms.
    func updateNSView(_ nsView: NSViewType, context: Context) {
        updatePlatformView(nsView, context: context)
    }
}
#endif

#if canImport(UIKit)
/// Detects whether the surrounding SwiftUI hierarchy is backed by a UIKit navigation controller.
///
/// The probe is attached outside PreferenceKit's own navigation container. It therefore identifies
/// navigation supplied by the host app and leaves standalone presentations unaffected.
@MainActor
struct PreferenceKitNavigationStackProbe: UIViewRepresentable {
    /// Receives the current host-navigation state.
    @Binding var isInNavigationStack: Bool

    /// Creates the coordinator that safely relays hierarchy changes into SwiftUI state.
    func makeCoordinator() -> Coordinator {
        Coordinator(isInNavigationStack: $isInNavigationStack)
    }

    /// Creates the invisible UIKit view that inspects its responder hierarchy.
    func makeUIView(context: Context) -> ProbeView {
        let view = ProbeView()
        view.reportNavigationStack = context.coordinator.reportNavigationStack
        return view
    }

    /// Refreshes the callback after SwiftUI updates the representable.
    func updateUIView(_ uiView: ProbeView, context: Context) {
        uiView.reportNavigationStack = context.coordinator.reportNavigationStack
        uiView.reportCurrentNavigationStack()
    }

    /// Relays UIKit hierarchy changes without mutating SwiftUI state during a view update.
    @MainActor
    final class Coordinator {
        private var reportedValue: Bool?
        private var isInNavigationStack: Binding<Bool>

        /// Creates a relay for the supplied SwiftUI state.
        init(isInNavigationStack: Binding<Bool>) {
            self.isInNavigationStack = isInNavigationStack
        }

        /// Publishes a changed navigation-container value on the next main-loop turn.
        func reportNavigationStack(_ value: Bool) {
            guard reportedValue != value else { return }
            reportedValue = value
            DispatchQueue.main.async { [weak self] in
                self?.isInNavigationStack.wrappedValue = value
            }
        }
    }

    /// An invisible view that finds the nearest view controller and its navigation ancestors.
    final class ProbeView: UIView {
        /// Callback invoked when the UIKit navigation hierarchy changes.
        var reportNavigationStack: ((Bool) -> Void)?

        /// Creates an inert probe that VoiceOver and other assistive technologies ignore.
        override init(frame: CGRect) {
            super.init(frame: frame)
            isAccessibilityElement = false
            isUserInteractionEnabled = false
        }

        /// Creates an inert probe from an archived interface hierarchy.
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            isAccessibilityElement = false
            isUserInteractionEnabled = false
        }

        /// Rechecks the hierarchy after UIKit attaches the view to a window.
        override func didMoveToWindow() {
            super.didMoveToWindow()
            reportCurrentNavigationStack()
        }

        /// Reports whether any owning controller is part of a UIKit navigation controller.
        func reportCurrentNavigationStack() {
            var controller = nearestViewController
            while let currentController = controller {
                if currentController is UINavigationController || currentController.navigationController != nil {
                    reportNavigationStack?(true)
                    return
                }
                controller = currentController.parent
            }
            reportNavigationStack?(false)
        }

        /// Finds the first view controller in the UIKit responder chain.
        private var nearestViewController: UIViewController? {
            var responder = next
            while let currentResponder = responder {
                if let viewController = currentResponder as? UIViewController { return viewController }
                responder = currentResponder.next
            }
            return nil
        }
    }
}
#endif
#endif
