//
//  RemoteConfigNetwork.swift
//
//
//  Created by Songming on 2024/2/27.
//

import Foundation

class RemoteConfigNetwork {
    
    struct ResponseModel: Codable {
        var status: Int
        var error: String?
        var message: String?
        var data: [String: String?]?
    }
    
    private lazy var url: URL = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "vercel-config-center.vercel.app"
        components.path = "/api/config"
        components.queryItems = [URLQueryItem(name: "bundle_id", value: bundleId)]
        return components.url!
    }()
    
    private (set) var model: ResponseModel?
    private (set) var rawData: Data?
    
    let bundleId: String
    
    init(bundleId: String) {
        self.bundleId = bundleId
    }
    
    func request() async throws {
        let session = URLSession(configuration: .default)
        let (data, resp) = try await session.data(from: url)
        guard let resp = resp as? HTTPURLResponse else {
            return
        }
        guard resp.statusCode >= 200 && resp.statusCode < 400 else {
            return
        }
        rawData = data
        let decoder = JSONDecoder()
        model = try decoder.decode(ResponseModel.self, from: data)
    }
}
