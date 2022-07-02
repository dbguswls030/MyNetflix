//
//  MovieViewModel.swift
//  MyNetflix
//
//  Created by 유현진 on 2022/07/02.
//

import Foundation

class MovieViewModel{
    
    private let manager = MovieManager.shared
    
    var numOfSection: Int{
        return manager.movies.count
    }
    
    var getMoives: [Movie]{
        return manager.movies
    }
    
    func loadMovie(movies: [Movie]){
        manager.initMoives(moives: movies)
    }
    
    func getMovie(index: Int) -> Movie{
        return manager.movies[index]
    }
    
}
