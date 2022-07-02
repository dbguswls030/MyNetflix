//
//  MovieResponse.swift
//  MyNetflix
//
//  Created by 유현진 on 2022/07/02.
//

import Foundation

struct MovieResponse: Codable{
    let resultCount: Int
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey{
        case resultCount
        case results
    }
}
