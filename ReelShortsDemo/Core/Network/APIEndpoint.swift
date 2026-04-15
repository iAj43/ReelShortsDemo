//
//  APIEndpoint.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import Foundation

struct APIEndpoint {

    let path: String
    let queryItems: [URLQueryItem]

    func url() throws -> URL {

        guard var components = URLComponents(string: APIConfig.baseURL) else {
            throw APIError.invalidURL
        }

        components.path += path
        components.queryItems = queryItems

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        return url
    }

    var headers: [String: String] {
        APIConfig.defaultHeaders
    }
}

extension APIEndpoint {

    static func reels(page: Int) -> APIEndpoint {
        APIEndpoint(
            path: "/popular",
            queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "20")
            ]
        )
    }
}
