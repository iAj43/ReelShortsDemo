//
//  APIService.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import Foundation

final class APIService {

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {

        let url = try endpoint.url()

        var request = URLRequest(url: url)
        endpoint.headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              200...299 ~= http.statusCode else {
            throw APIError.invalidResponse
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
