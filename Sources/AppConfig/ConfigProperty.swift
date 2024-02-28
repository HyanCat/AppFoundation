//
//  ConfigProperty.swift
//
//
//  Created by Songming on 2024/2/27.
//

import Foundation

@propertyWrapper
public struct Config {
    
    let key: String
    
    private let defaultValue: String?
    
    public var wrappedValue: String? {
        get {
            return ConfigManager.shared.stringValue(for: key) ?? defaultValue
        }
        set {
            fatalError("Can not set this property!")
        }
    }
    
    public init(_ key: String, `default`: String? = nil) {
        self.key = key
        self.defaultValue = `default`
    }
}

@propertyWrapper
public struct BoolConfig {
    
    let key: String
    
    private let defaultValue: Bool
    
    public var wrappedValue: Bool {
        get {
            return ConfigManager.shared.boolValue(for: key, default: defaultValue)
        }
        set {
            fatalError("Can not set this property!")
        }
    }
    
    public init(_ key: String, `default`: Bool = false) {
        self.key = key
        self.defaultValue = `default`
    }
}
