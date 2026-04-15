//
//  VideoCacheManager.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import Foundation

final class VideoCacheManager {

    static let shared = VideoCacheManager()

    func localURL(for url: URL) -> URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent(url.lastPathComponent)
    }

    func isCached(url: URL) -> Bool {
        FileManager.default.fileExists(atPath: localURL(for: url).path)
    }
}
