//
//  APIConfig.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import Foundation

enum APIConfig {
    static let baseURL = "https://api.pexels.com/videos"
    static let apiKey = "" // optional: add if required by API
    
    static var defaultHeaders: [String: String] {
        guard !apiKey.isEmpty else { return [:] }
        return ["Authorization": apiKey]
    }
}
