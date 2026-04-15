//
//  ReelPlayerView.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import SwiftUI
import AVKit

struct ReelPlayerView: View {

    let reel: Reel
    let isActive: Bool

    @State private var thumbnailOpacity: Double = 1

    var body: some View {

        ZStack {

            VideoPlayer(player: PlayerManager.shared.player)
                .id("GLOBAL_PLAYER")
                .disabled(true)
                .allowsHitTesting(false)
                .ignoresSafeArea()

            AsyncImage(url: URL(string: reel.thumbnail)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.black
            }
            .opacity(thumbnailOpacity)
            .ignoresSafeArea()
        }
        .onAppear {
            if isActive { play() }
        }
        .onChange(of: isActive) { _, newValue in
            newValue ? play() : PlayerManager.shared.pause()
        }
    }

    private func play() {

        thumbnailOpacity = 1

        guard let url = URL(string: reel.videoURL) else { return }

        let playURL = VideoCacheManager.shared.isCached(url: url)
            ? VideoCacheManager.shared.localURL(for: url)
            : url

        PlayerManager.shared.play(url: playURL)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.easeOut(duration: 0.2)) {
                thumbnailOpacity = 0
            }
        }
    }
}
