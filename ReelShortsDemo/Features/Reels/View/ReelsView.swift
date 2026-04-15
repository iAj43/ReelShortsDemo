//
//  ReelsView.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import SwiftUI

struct ReelsView: View {

    @StateObject private var vm = AppContainer.shared.makeVM()
    @State private var activeIndex: Int = 0

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            TabView(selection: $activeIndex) {

                ForEach(Array(vm.reels.enumerated()), id: \.element.id) { index, reel in

                    ReelPlayerView(
                        reel: reel,
                        isActive: activeIndex == index
                    )
                    .tag(index)
                    .onAppear {
                        Task {
                            await vm.loadMoreIfNeeded(current: reel)
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // LOADING
            if vm.reels.isEmpty && vm.isLoading {
                VStack {
                    ProgressView("Loading...")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            // ERROR
            if let error = vm.error, vm.reels.isEmpty {
                VStack {
                    Text(error)
                        .foregroundColor(.white)

                    Button("Retry") {
                        Task { await vm.load() }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
            }

            // OVERLAY (PLAYER CONTROLS)
            if let reel = vm.reels[safe: activeIndex] {
                overlayView(reel: reel)
            }
        }
        .task {
            await vm.load()
            activeIndex = 0
        }
    }

    private func overlayView(reel: Reel) -> some View {

        VStack {
            Spacer()

            HStack {
                VStack(alignment: .leading, spacing: 12) {

                    Text("@\(reel.userName)")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(formatDuration(reel.duration))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))

                    PlayerControlsView()
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
    }

    private func formatDuration(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
