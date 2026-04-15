//
//  ReelsViewModelTests.swift
//  ReelShortsDemo
//
//  Created by IA on 16/04/26.
//

import XCTest
@testable import ReelShortsDemo

@MainActor
final class ReelsViewModelTests: XCTestCase {

    // MARK: - Mock Repository
    final class MockReelsRepository: ReelsRepositoryProtocol {

        var shouldFail = false
        var mockPages: [[Reel]] = []
        private var callCount = 0

        func fetch(page: Int) async throws -> [Reel] {
            if shouldFail {
                throw APIError.noData
            }

            guard callCount < mockPages.count else { return [] }
            let result = mockPages[callCount]
            callCount += 1
            return result
        }
    }

    // MARK: - Test Success Load
    func testLoadSuccess() async {

        let mockRepo = MockReelsRepository()
        mockRepo.mockPages = [
            [Reel(id: 1, videoURL: "url1", thumbnail: "thumb1", userName: "user1", duration: 10)]
        ]

        let vm = ReelsViewModel(repo: mockRepo)

        await vm.load()

        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.error)
        XCTAssertEqual(vm.reels.count, 1)
    }

    // MARK: - Test Failure
    func testLoadFailure() async {

        let mockRepo = MockReelsRepository()
        mockRepo.shouldFail = true

        let vm = ReelsViewModel(repo: mockRepo)

        await vm.load()

        XCTAssertFalse(vm.isLoading)
        XCTAssertNotNil(vm.error)
        XCTAssertTrue(vm.reels.isEmpty)
    }

    // MARK: - Test Pagination
    func testLoadMoreIfNeededTriggersPagination() async {

        let mockRepo = MockReelsRepository()
        mockRepo.mockPages = [
            [Reel(id: 1, videoURL: "url1", thumbnail: "thumb1", userName: "user1", duration: 10)],
            [Reel(id: 2, videoURL: "url2", thumbnail: "thumb2", userName: "user2", duration: 20)]
        ]

        let vm = ReelsViewModel(repo: mockRepo)

        await vm.load()

        guard let last = vm.reels.last else {
            XCTFail("No last element")
            return
        }

        await vm.loadMoreIfNeeded(current: last)

        XCTAssertEqual(vm.reels.count, 2)
    }

    // MARK: - Prevent Duplicate Load
    func testLoadDoesNotRunWhenAlreadyLoading() async {

        let mockRepo = MockReelsRepository()
        mockRepo.mockPages = [
            [Reel(id: 1, videoURL: "url1", thumbnail: "thumb1", userName: "user1", duration: 10)]
        ]

        let vm = ReelsViewModel(repo: mockRepo)
        vm.isLoading = true

        await vm.load()

        XCTAssertTrue(vm.reels.isEmpty)
    }

    // MARK: - Preload Trigger
    func testPreloadIfNeededTriggersLoad() async {

        let mockRepo = MockReelsRepository()
        mockRepo.mockPages = [
            [Reel(id: 1, videoURL: "url1", thumbnail: "thumb1", userName: "user1", duration: 10)],
            [Reel(id: 2, videoURL: "url2", thumbnail: "thumb2", userName: "user2", duration: 20)]
        ]

        let vm = ReelsViewModel(repo: mockRepo)

        await vm.load()

        let index = vm.reels.count - 1
        await vm.preloadIfNeeded(index: index)

        XCTAssertEqual(vm.reels.count, 2)
    }
}
