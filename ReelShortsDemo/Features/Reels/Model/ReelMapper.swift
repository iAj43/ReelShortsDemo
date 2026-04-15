//
//  ReelMapper.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import Foundation

struct ReelMapper {

    static func map(_ item: VideoItem) -> Reel? {

        // prefer hd or fallback to any available
        guard let file = item.videoFiles.first(where: { $0.quality == "hd" }) ??
                        item.videoFiles.first else { return nil }

        return Reel(
            id: item.id,
            videoURL: file.link,
            thumbnail: item.image,
            userName: item.user.name,
            duration: item.duration
        )
    }
}
