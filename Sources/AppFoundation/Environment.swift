//
//  Environment.swift
//  Valley
//
//  Created by Songming on 2023/6/21.
//  Copyright © 2023 hyancat. All rights reserved.
//

import Foundation

public enum Environment: UInt8 {
    case production
    case development
    case test
}

extension Environment: CustomStringConvertible {
    public var description: String {
        switch self {
        case .production:
            return "production"
        case .development:
            return "development"
        case .test:
            return "test"
        }
    }
}

public class EnvironmentManager {
    
    public static let shared = EnvironmentManager()
    
    var current: Environment
    
    var allEnvironments: [Environment] = [.development, .test, .production]
    
    init() {
        let value = UserDefaults.standard.integer(forKey: "Environment")
        // default should be production(0)
        self.current = Environment(rawValue: UInt8(value)) ?? .production
    }
    
    public func switchTo(env: Environment, reboot: Bool = false) {
        current = env
        UserDefaults.standard.set(env.rawValue, forKey: "Environment")
        if (reboot) {
            self.reboot()
        }
    }
    
    private func reboot() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            exit(0)
        }
    }
}

@propertyWrapper
public struct EnvironmentDefine<Value> {
    
    public var productionValue: Value
    public var developmentValue: Value?
    public var testValue: Value?
    
    public var wrappedValue: Value {
        get {
            switch EnvironmentManager.shared.current {
            case .production:
                return productionValue
            case .development:
                return developmentValue ?? productionValue
            case .test:
                return testValue ?? productionValue
            }
        }
        set {
            fatalError("You cannot set this property!")
        }
    }
    
    public init(productionValue: Value, developmentValue: Value? = nil, testValue: Value? = nil) {
        self.productionValue = productionValue
        self.developmentValue = developmentValue
        self.testValue = testValue
    }
}
