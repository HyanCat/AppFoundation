//
//  Storage.swift
//  Valley
//
//  Created by HyanCat on 2023/6/11.
//  Copyright © 2023 hyancat. All rights reserved.
//

import Foundation
import SwiftLMDB

public class Storage {
    
    public static let `default` = Storage()
    private var database: Database?
    
    init(namespace: String = "default") {
        assert(!Thread.isMainThread)
        do {
            // The folder in which the environment is opened must already exist.
            guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Unable to retrieve document directory URL.")
                return
            }
            
            print("Document Directory URL: \(documentDirectoryURL)")
            
            let lmdbURL: URL
            if #available(iOS 16.0, macOS 13.0, *) {
                lmdbURL = documentDirectoryURL.appending(component: "lmdb")
            } else {
                var mutableURL = documentDirectoryURL
                mutableURL.appendPathComponent("lmdb")
                lmdbURL = mutableURL
            }
            
            try FileManager.default.createDirectory(at: lmdbURL, withIntermediateDirectories: true, attributes: nil)
            
            var flags: Environment.Flags = []
#if os(macOS)
            flags.insert(.noLock)
#endif
            let environment = try Environment(path: lmdbURL.path, flags: flags, maxDBs: 32)
            database = try environment.openDatabase(named: namespace, flags: [.create])
            
        } catch {
            print(error)
        }
        
    }
    
    private func saveNonnull<T: DataConvertible>(key: String, value: T) {
        assert(!Thread.isMainThread)
        guard let database else { return }
        do {
            try database.put(value: value, forKey: key)
        } catch {
            print(error)
        }
    }
    
    public func saveData<T: DataConvertible>(key: String, value: T?) {
        assert(!Thread.isMainThread)
        guard let value else {
            delete(key: key)
            return
        }
        saveNonnull(key: key, value: value)
    }
    
    public func readData<T: DataConvertible>(key: String) -> T? {
        assert(!Thread.isMainThread)
        guard let database else { return nil }
        do {
            let value = try database.get(type: T.self, forKey: key)
            return value
        } catch {
            print(error)
        }
        return nil
    }
    
    public func has(key: String) -> Bool {
        assert(!Thread.isMainThread)
        guard let database else { return false }
        do {
            return try database.exists(key: key)
        } catch {
            print(error)
        }
        return false
    }
    
    public func delete(key: String) {
        assert(!Thread.isMainThread)
        guard let database else { return }
        do {
            try database.deleteValue(forKey: key)
        } catch {
            print(error)
        }
    }
    
    public func clean() {
        assert(!Thread.isMainThread)
        guard let database else { return }
        do {
            try database.empty()
        } catch {
            print(error)
        }
    }
    
}

extension Storage {
    
    public func save<T: Encodable>(key: String, value: T?) {
        guard let value else {
            delete(key: key)
            return
        }
        do {
            let data = try JSONEncoder().encode(value)
            saveData(key: key, value: data)
        } catch {
            print(error)
        }
    }
    
    public func read<T: Decodable>(key: String) -> T? {
        let data: Data? = readData(key: key)
        guard let data else {
            return nil
        }
        do {
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch {
            print(error)
        }
        return nil
    }
}
