//
//  PresentableContentView.swift
//  ValleyApp
//
//  Created by HyanCat on 2023/6/23.
//  Copyright © 2023 hyancat. All rights reserved.
//

import SwiftUI

public struct PresentableContentView<Content: View>: View {
    
    public let content: () -> Content
    
    public var body: some View {
        if #available(iOS 15.0, *) {
            PresentableContentWrappedView() {
                content()
            }
        } else {
            PresentableContentWrappedView14() {
                content()
            }
        }
    }
    
    public init(content: @escaping () -> Content) {
        self.content = content
    }
}

@available(iOS 15.0, *)
struct PresentableContentWrappedView<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    let content: () -> Content
    
    var body: some View {
        ZStack {
            content()
                .environment(\.dismissActor, DismissActor {
                    dismiss()
                })
            GeometryReader { proxy in
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                }
                .foregroundColor(colorScheme == .light ? .black : Color(.lightGray))
                .frame(width: 44, height: 44)
                .position(x: proxy.size.width - 22 - 8, y: 22 + 8)
            }
        }
        .interactiveDismissDisabled()
    }
}

struct PresentableContentWrappedView14<Content: View>: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    let content: () -> Content
    
    var body: some View {
        ZStack {
            content()
                .environment(\.dismissActor, DismissActor {
                    presentationMode.wrappedValue.dismiss()
                })
            GeometryReader { proxy in
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                }
                .foregroundColor(colorScheme == .light ? .black : Color(.lightGray))
                .frame(width: 44, height: 44)
                .position(x: proxy.size.width - 22 - 8, y: 22 + 8)
            }
        }
    }
}
