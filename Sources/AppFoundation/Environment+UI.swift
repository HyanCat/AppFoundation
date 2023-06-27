//
//  Environment+UI.swift
//
//  Created by Songming on 2023/6/21.
//  Copyright © 2023 hyancat. All rights reserved.
//

import UIKit

extension EnvironmentManager {
    
    @available(iOS 13, *)
    public func showEnvironmentConfiguration() {
        let alert = UIAlertController(title: "Environments", message: "You can switch environment below", preferredStyle: .actionSheet)
        allEnvironments.forEach { env in
            let action = UIAlertAction(title: env.description.capitalized, style: .default) { _ in
                self.switchTo(env: env, reboot: true)
            }
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        
        let window = UIApplication.shared.mainWindow
        window?.rootViewController?.present(alert, animated: true)
    }
    
}
