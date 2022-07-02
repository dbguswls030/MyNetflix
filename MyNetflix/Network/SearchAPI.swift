//
//  SearchAPI.swift
//  MyNetflix
//
//  Created by 유현진 on 2022/06/28.
//

import Foundation
class SearchAPI{
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
}
