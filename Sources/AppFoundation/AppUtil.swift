//
//  AppUtil.swift
//  XianWen
//
//  Created by Songming on 2023/5/23.
//

import Foundation

public struct AppInfo: Sendable {
    
    public static var appName: String {
        guard let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String else {
            return ""
        }
        return name
    }
    
    public static var localizedAppName: String {
        guard let infoDictionary = Bundle.main.localizedInfoDictionary else {
            return ""
        }
        
        if let displayName = infoDictionary["CFBundleDisplayName"] as? String {
            return displayName
        } else if let bundleName = infoDictionary["CFBundleName"] as? String {
            return bundleName
        } else {
            return ""
        }
    }
    
    public static var appVersion: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return ""
        }
        return version
    }
    
    public static var buildVersion: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return ""
        }
        return version
    }
}
