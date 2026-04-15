//
//  VideoDownloadManager.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import Foundation

final class VideoDownloadManager: NSObject, URLSessionDownloadDelegate {

    static let shared = VideoDownloadManager()

    lazy var session: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "video-download")
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()

    func download(url: URL) {
        session.downloadTask(with: url).resume()
    }

    // MARK: - save to cache
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

        guard let sourceURL = downloadTask.originalRequest?.url else { return }

        let destination = VideoCacheManager.shared.localURL(for: sourceURL)

        do {
            try? FileManager.default.removeItem(at: destination)
            try FileManager.default.moveItem(at: location, to: destination)
        } catch {
            print("Cache save error:", error)
        }
    }
}
