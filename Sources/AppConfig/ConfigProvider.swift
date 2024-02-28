//
//  ConfigProvider.swift
//
//
//  Created by Songming on 2024/2/27.
//

import Foundation
import AppFoundation

protocol ConfigProvider {
    
    typealias ConfigList = [String: String]
    
    var data: Data? { get set }
    
    var configList: ConfigList? { get set }
    
    func fetchConfig(namespace: String) async
    
}

extension ConfigProvider {
    
    func stringValue(for key: String) -> String? {
        guard let configList else {
            return nil
        }
        return configList[key]
    }
    
}

class BundleConfigProvider: ConfigProvider {
    
    var data: Data?
    var configList: ConfigList?
    
    func fetchConfig(namespace: String) async {
        guard let url = Bundle.main.url(forResource: namespace, withExtension: "json") else {
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        
        print("read bundle config `\(namespace)`, data: \(data)")
        
        self.data = data
        do {
            let list = try JSONDecoder().decode(ConfigList.self, from: data)
            configList = list
        } catch {
            print("fetch bundle config failed! error=\(error)")
        }
    }
}

class LocalDB {
    
    static let `default` = LocalDB()
    
    func saveConfig(namespace: String, data: Data) async {
        Storage.default.saveData(key: "app:config:\(namespace)", value: data)
        print("cache config `\(namespace)`, data: \(data)")
    }
    
    func removeConfig(namespace: String) {
        Storage.default.delete(key: "app:config:\(namespace)")
        print("remove cache config `\(namespace)`")
    }
    
    func readConfig(namespace: String) async -> Data? {
        let data: Data? = Storage.default.readData(key: "app:config:\(namespace)")
        print("read cache config `\(namespace)`, data: \(data?.description ?? "nil")")
        return data
    }
}

class LocalConfigProvider: ConfigProvider {

    var data: Data?
    var configList: ConfigList?
    
    func fetchConfig(namespace: String) async {
        guard let data = await LocalDB.default.readConfig(namespace: namespace) else {
            print("fetch local config no data!")
            return
        }
        self.data = data
        do {
            let list = try JSONDecoder().decode(ConfigList.self, from: data)
            configList = list
        } catch {
            print("fetch local config failed! error=\(error)")
        }
    }
}

class RemoteConfigProvider: ConfigProvider, ConfigAccessor {
    
    var data: Data?
    var configList: ConfigList?
    
    func fetchConfig(namespace: String) async {
        let network = RemoteConfigNetwork(bundleId: namespace)
        do {
            try await network.request()
            guard let modelData = network.model?.data else {
                return
            }
            let list = modelData.compactMapValues { value in
                value
            }
            let data = try JSONEncoder().encode(list)
            self.data = data
            await LocalDB.default.saveConfig(namespace: namespace, data: data)
            configList = list
        } catch {
            print("request remote config failed! error=\(error)")
        }
    }
}
