//
//  PlayerManager.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import AVFoundation 
import AVKit

final class PlayerManager {

    static let shared = PlayerManager()

    private init() {
        player.automaticallyWaitsToMinimizeStalling = true
        player.actionAtItemEnd = .none
        setupPiP()
    }

    let player = AVPlayer()

    private var pipController: AVPictureInPictureController?
    private var currentURL: URL?
    private var statusObserver: NSKeyValueObservation?
    private var endObserver: NSObjectProtocol?
    
    // MARK: - PiP Setup
    private func setupPiP() {
        guard AVPictureInPictureController.isPictureInPictureSupported() else { return }
        let layer = AVPlayerLayer(player: player)
        pipController = AVPictureInPictureController(playerLayer: layer)
    }

    func startPiP() {
        pipController?.startPictureInPicture()
    }

    func stopPiP() {
        pipController?.stopPictureInPicture()
    }

    func play(url: URL) {

        // prevent reload
        guard currentURL != url else {
            if player.timeControlStatus != .playing {
                player.play()
            }
            return
        }

        currentURL = url

        let item = AVPlayerItem(url: url)
        item.preferredForwardBufferDuration = 5

        // cleanup old observers
        statusObserver?.invalidate()
        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
        }

        // observe ready state
        statusObserver = item.observe(\.status, options: [.new]) { [weak self] item, _ in
            guard let self else { return }

            if item.status == .readyToPlay {
                self.player.playImmediately(atRate: 1.0)
            }
        }

        // loop video
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.player.seek(to: .zero)
            self.player.play()
        }
        
        player.replaceCurrentItem(with: item)
    }

    func pause() {
        player.pause()
    }

    deinit {
        statusObserver?.invalidate()
        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
        }
    }
}
