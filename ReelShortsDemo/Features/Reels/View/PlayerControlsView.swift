//
//  PlayerControlsView.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import SwiftUI
import AVFoundation

struct PlayerControlsView: View {

    @State private var progress: Double = 0
    @State private var duration: Double = 0

    private let player = PlayerManager.shared.player
    @State private var timeObserver: Any?

    var body: some View {

        VStack(spacing: 10) {

            if duration > 0 {
                Slider(value: $progress, in: 0...duration) { editing in
                    if !editing {
                        let time = CMTime(seconds: progress, preferredTimescale: 600)
                        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
                    }
                }
            }

            HStack {

                Button {
                    player.timeControlStatus == .playing ? player.pause() : player.play()
                } label: {
                    Image(systemName: player.timeControlStatus == .playing ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                }

                Spacer()

                if duration > 0 {
                    Text("\(format(progress)) / \(format(duration))")
                        .font(.caption)
                        .foregroundColor(.white)
                }

                Spacer()

                Button {
                    guard let url = (player.currentItem?.asset as? AVURLAsset)?.url else { return }
                    VideoDownloadManager.shared.download(url: url)
                } label: {
                    Image(systemName: "arrow.down.circle")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button {
                    PlayerManager.shared.startPiP()
                } label: {
                    Image(systemName: "pip")
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .onAppear {
            addObserver()
        }
        .onDisappear {
            removeObserver()
        }
        .onReceive(NotificationCenter.default.publisher(
            for: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )) { _ in
            reset()
        }
    }

    private func reset() {
        progress = 0
        duration = 0
        removeObserver()
        addObserver()
    }

    private func addObserver() {

        guard timeObserver == nil else { return }

        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)

        timeObserver = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { time in
            let current = time.seconds
            let total = player.currentItem?.duration.seconds ?? 0

            guard total.isFinite, total > 0 else { return }

            duration = total
            progress = min(current, total)
        }
    }

    private func removeObserver() {
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
            timeObserver = nil
        }
    }

    private func format(_ value: Double) -> String {
        String(format: "%02d:%02d", Int(value) / 60, Int(value) % 60)
    }
}
