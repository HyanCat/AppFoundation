//
//  Environment.swift
//  Valley
//
//  Created by Songming on 2023/6/21.
//  Copyright © 2023 hyancat. All rights reserved.
//

import Foundation

public enum Env: UInt8 {
    case production
    case development
    case test
}

extension Env: CustomStringConvertible {
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

public class EnvManager {
    
    public static let shared = EnvManager()
    
    var currentEnv: Env
    
    var allEnvs: [Env] = [.development, .test, .production]
    
    init() {
        let value = UserDefaults.standard.integer(forKey: "Env")
        // default should be production(0)
        currentEnv = Env(rawValue: UInt8(value)) ?? .production
    }
    
    public func switchTo(env: Env, reboot: Bool = false) {
        currentEnv = env
        UserDefaults.standard.set(env.rawValue, forKey: "Env")
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
public struct EnvDefine<Value> {
    
    public var productionValue: Value
    public var developmentValue: Value?
    public var testValue: Value?
    
    public var wrappedValue: Value {
        get {
            switch EnvManager.shared.currentEnv {
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
