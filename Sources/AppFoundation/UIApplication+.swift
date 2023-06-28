//
//  UIApplication+.swift
//  Valley
//
//  Created by Songming on 2023/6/27.
//  Copyright © 2023 hyancat. All rights reserved.
//

import UIKit

extension UIApplication {
    
    public var mainWindow: UIWindow? {
        let window = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .last { $0.isKeyWindow }
        return window
    }
    
}
