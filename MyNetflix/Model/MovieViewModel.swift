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
//    static let movieGenre = ["Documentary", "romance", "Kids & Family", "Action & Adventure", "Drama", "Sports", "Musicals"]
    enum genreType: String{
        case Documentary
        case romance
        case kid = "Kids & Family"
        case action = "Action & Adventure"
        case Drama
        case Sports
        case Musical
        
        var title: String{
            switch self{
            case .Documentary: return "다큐멘터리"
            case .romance: return "로맨스"
            case .kid: return "어린이 & 가족"
            case .action: return "액션"
            case .Drama: return "드라마"
            case .Sports: return "스포츠"
            case .Musical: return "뮤지컬"
            }
        }
    }
    
    
}
