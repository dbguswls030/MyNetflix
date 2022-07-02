//
//  MovieManager.swift
//  MyNetflix
//
//  Created by 유현진 on 2022/07/02.
//

import Foundation
class MovieManager{
    static let shared = MovieManager()
    
    var movies = [Movie]()
    
    func initMoives(moives: [Movie]){
        self.movies = moives
    }
    //생성, 추가, 삭제
}
