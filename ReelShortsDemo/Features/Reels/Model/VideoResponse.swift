//
//  VideoResponse.swift
//  ReelShortsDemo
//
//  Created by IA on 15/04/26.
//

import Foundation

struct VideoResponse: Codable {
    let videos: [VideoItem]
}

struct VideoItem: Codable {

    let id: Int
    let image: String
    let duration: Int
    let user: User
    let videoFiles: [VideoFile]

    enum CodingKeys: String, CodingKey {
        case id, image, duration, user
        case videoFiles = "video_files"
    }
}

struct User: Codable {
    let name: String
}

struct VideoFile: Codable {
    let quality: String
    let link: String
}
