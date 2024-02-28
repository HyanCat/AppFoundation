//
//  ConfigManager.swift
//
//
//  Created by Songming on 2024/2/27.
//

import Foundation

protocol ConfigAccessor {
    func stringValue(for key: String) -> String?
}

public class ConfigManager {
    
    public static let shared = ConfigManager()
        
    private let bundleConfigProvider = BundleConfigProvider()
    private let localConfigProvider = LocalConfigProvider()
    private let remoteConfigProvider = RemoteConfigProvider()
    
    public func launch(bundleId: String) async {
        Task {
            await remoteConfigProvider.fetchConfig(namespace: bundleId)
        }
        Task {
            await localConfigProvider.fetchConfig(namespace: bundleId)
        }
        Task {
            await bundleConfigProvider.fetchConfig(namespace: bundleId)
        }
    }
}

extension ConfigManager: ConfigAccessor {
    
    func stringValue(for key: String) -> String? {
        if let value = remoteConfigProvider.stringValue(for: key) {
            return value
        }
        if let value = localConfigProvider.stringValue(for: key) {
            return value
        }
        if let value = bundleConfigProvider.stringValue(for: key) {
            return value
        }
        return nil
    }
    
    func boolValue(for key: String, default: Bool = false) -> Bool {
        if let value = stringValue(for: key) {
            return Bool(str: value)
        }
        return `default`
    }
}

extension Bool {
    init(str: String?) {
        if let str {
            let lower = str.lowercased()
            if lower == "true" || lower == "yes" || lower == "1" {
                self = true
            }
        }
        self = false
    }
}
