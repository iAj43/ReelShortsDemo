//
//  ReelsRepository.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import Foundation

protocol ReelsRepositoryProtocol {
    func fetch(page: Int) async throws -> [Reel]
}

final class ReelsRepository: ReelsRepositoryProtocol {

    private let api: APIService

    init(api: APIService) {
        self.api = api
    }

    func fetch(page: Int) async throws -> [Reel] {

        let response: VideoResponse = try await api.request(.reels(page: page))

        guard !response.videos.isEmpty else {
            throw APIError.noData
        }

        return response.videos.compactMap {
            ReelMapper.map($0)
        }
    }
}
