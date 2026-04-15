//
//  APIError.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decoding
    case network(Error)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .decoding:
            return "Failed to decode data"
        case .network(let error):
            return error.localizedDescription
        case .noData:
            return "No data available"
        }
    }
}
