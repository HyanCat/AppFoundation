//
//  NotificationCenter+.swift
//  Valley
//
//  Created by Songming on 2023/6/26.
//  Copyright © 2023 hyancat. All rights reserved.
//

import SwiftUI

extension View {
    
    @inlinable public func onReceive(notification name: Notification.Name, perform action: @escaping (Notification) -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: name), perform: action)
    }
    
}
