//
//  SearchAPI.swift
//  MyNetflix
//
//  Created by 유현진 on 2022/06/28.
//

import Foundation
class SearchAPI{
    // Documentary, romance, Kids & Family, Action & Adventure, Drama, Sports, Musicals
    static let movieGenre = ["Documentary", "romance", "Kids & Family", "Drama", "Sports", "Musicals"]
    static func search(term: String, completion: @escaping ([Movie]) -> Void){
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entityQuery = URLQueryItem(name: "entity", value: "movie")
        let termQuery = URLQueryItem(name: "term", value: term)
        
        urlComponents.queryItems?.append(mediaQuery)
        urlComponents.queryItems?.append(entityQuery)
        urlComponents.queryItems?.append(termQuery)
        let requestUrl = urlComponents.url!
        
        let dataTask = session.dataTask(with: requestUrl) { data, response, error in
            guard error == nil else{
                print("Error occur: \(String(describing: error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else{
                completion([])
                return
            }
            guard let resultData = data else{
                completion([])
                return
            }
            do{
                let decodeData = try JSONDecoder().decode(MovieResponse.self, from: resultData)
                completion(decodeData.results)
            }catch let error{
                print("Decoder Error : \(error.localizedDescription)")
            }
//            let string = String(data: resultData, encoding: .utf8)
//            print(string)
            
        }
        dataTask.resume()
    }
    
    static func recommendItemListWithGenre(term: String, completion: @escaping ([Movie]) -> Void){
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entityQuery = URLQueryItem(name: "entity", value: "movie")
        let attributeQuery = URLQueryItem(name: "attribute", value: "genreTerm")
        let termQuery = URLQueryItem(name: "term", value: term)
        
        urlComponents.queryItems?.append(mediaQuery)
        urlComponents.queryItems?.append(entityQuery)
        urlComponents.queryItems?.append(attributeQuery)
        urlComponents.queryItems?.append(termQuery)
        let requestUrl = urlComponents.url!
        let dataTask = session.dataTask(with: requestUrl) { data, response, error in
            
            guard error == nil else {
                print("Error occur : \(String(describing: error))")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else{
                completion([])
                return
            }
            
            guard let resultData = data else{
                completion([])
                return
            }
            
            do{
                let decodeData = try JSONDecoder().decode(MovieResponse.self, from: resultData)
                completion(decodeData.results)
            }catch let error{
                print("Decode Error : \(error.localizedDescription)")
            }
//            let string = String(data: resultData, encoding: .utf8)
//            print(string)
        }
        dataTask.resume()
    }
    
    static func recommendOneItem(completion: @escaping ([Movie]) -> Void){
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entitiyQuery = URLQueryItem(name: "entity", value: "movie")
        let termQuery = URLQueryItem(name: "term", value: "marvel")
        let limitQuery = URLQueryItem(name: "limit", value: "1")
        
        urlComponents.queryItems?.append(mediaQuery)
        urlComponents.queryItems?.append(entitiyQuery)
        urlComponents.queryItems?.append(limitQuery)
        urlComponents.queryItems?.append(termQuery)
        let requestURL = urlComponents.url!
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            guard error == nil else{
                print("Error Occur : \(String(describing: error))")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else{
                completion([])
                return
            }
            guard let resultData = data else{
                completion([])
                return
            }
            do{
                let decodeData = try JSONDecoder().decode(MovieResponse.self, from: resultData)
                completion(decodeData.results)
            }catch let error{
                print("Decode Error : \(error.localizedDescription)")
            }
//            let string = String(data: resultData, encoding: .utf8)
//            print(string)
        }
        dataTask.resume()
    }
}
