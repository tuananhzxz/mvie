//
//  YoutubeSearchResultResponse.swift
//  MovieClone
//
//  Created by tuananhdo on 5/1/25.
//

import Foundation

struct YoutubeSearchResultResponse: Codable {
    let items: [YoutubeVideo]
}

struct YoutubeVideo: Codable {
    let id : IdVideoElement
}

struct IdVideoElement: Codable {
    let kind : String
    let videoId : String
}

