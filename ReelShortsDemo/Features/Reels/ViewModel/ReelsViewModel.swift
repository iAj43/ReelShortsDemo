//
//  ReelsViewModel.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import Foundation
internal import Combine

@MainActor
final class ReelsViewModel: ObservableObject {
    
    @Published var reels: [Reel] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let repo: ReelsRepositoryProtocol
    private var page = 1
    
    init(repo: ReelsRepositoryProtocol) {
        self.repo = repo
    }
    
    func load() async {
        
        guard !isLoading else { return } // prevent duplicate calls
        
        isLoading = true
        error = nil
        
        do {
            let data = try await repo.fetch(page: page)
            reels.append(contentsOf: data)
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadMoreIfNeeded(current: Reel) async {
        guard let last = reels.last, last.id == current.id else { return }
        await preloadIfNeeded(index: reels.count - 1)
    }
    
    func preloadIfNeeded(index: Int) async {
        guard index >= reels.count - 2 else { return }
        guard !isLoading else { return }

        isLoading = true

        let nextPage = page + 1

        do {
            let data = try await repo.fetch(page: nextPage)
            reels.append(contentsOf: data)
            page = nextPage
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }
}
