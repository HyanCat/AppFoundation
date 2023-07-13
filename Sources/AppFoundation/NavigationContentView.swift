//
//  NavigationContentView.swift
//  ValleyApp
//
//  Created by HyanCat on 2023/6/24.
//  Copyright © 2023 hyancat. All rights reserved.
//

import SwiftUI

extension EnvironmentValues {
    
    private struct DismissActorKey: EnvironmentKey {
        static let defaultValue: DismissActor = DismissActor {}
    }
    
    public var dismissActor: DismissActor {
        get {
            self[DismissActorKey.self]
        }
        set {
            self[DismissActorKey.self] = newValue
        }
    }
}

public class DismissActor {
    
    public var dismiss: (() -> Void)
    
    init(dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
    }
}

#if os(iOS)

public struct NavigationContentView<Content: View>: View {
    
    public let content: () -> Content
    
    public var body: some View {
        if #available(iOS 15.0, *) {
            NavigationContentWrappedView {
                content()
            }
        } else if #available(iOS 14, *) {
            NavigationContentWrappedView14 {
                content()
            }
        } else {
            content()
        }
    }
    
    public init(content: @escaping () -> Content) {
        self.content = content
    }
}

@available(iOS 15.0, *)
struct NavigationContentWrappedView<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    let content: () -> Content
    
    var body: some View {
        NavigationView {
            content()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .tint(colorScheme == .light ? .black : Color(.lightGray))
                    }
                }
                .environment(\.dismissActor, DismissActor {
                    dismiss()
                })
        }
        .navigationViewStyle(.stack)
        .interactiveDismissDisabled()
    }
}

/// Support tintColor
extension EnvironmentValues {
    private struct TintColor: EnvironmentKey {
        static let defaultValue: Color? = nil
    }
    
    var tintColor: Color? {
        get {
            self[TintColor.self]
        }
        set {
            self[TintColor.self] = newValue
        }
    }
}

@available(iOS 14.0, *)
struct NavigationContentWrappedView14<Content: View>: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    let content: () -> Content
    
    var body: some View {
        NavigationView {
            content()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .environment(\.tintColor, colorScheme == .light ? .black : Color(.lightGray))
                    }
                }
                .environment(\.dismissActor, DismissActor {
                    presentationMode.wrappedValue.dismiss()
                })
        }
        .navigationViewStyle(.stack)
    }
}

#endif
