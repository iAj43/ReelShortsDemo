//
//  AppContainer.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import Foundation

final class AppContainer {

    static let shared = AppContainer()

    func makeVM() -> ReelsViewModel {

        let api = APIService()
        let repo = ReelsRepository(api: api)

        return ReelsViewModel(repo: repo)
    }
}
