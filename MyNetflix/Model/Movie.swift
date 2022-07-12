//
//  Movie.swift
//  MyNetflix
//
//  Created by 유현진 on 2022/07/02.
//

import Foundation;

struct Movie: Codable{
    let title: String
    let director: String
    let thumbnailPath: String
    let preViewURL: String
    let genre: String
    
    enum CodingKeys: String, CodingKey{
        case title = "trackName"
        case director = "artistName"
        case thumbnailPath = "artworkUrl100"
        case preViewURL = "previewUrl"
        case genre = "primaryGenreName"
    }
}
