//
//  ViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

import UIKit
import Alamofire

struct MovieService {
    let apiKey = "e49616da-1372-491a-840e-81a87afe3e6e"

    func loadImage(urlString: String) -> UIImage? {
        guard
            let url = URL(string: urlString),
            let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        
        return UIImage(data: data)
    }
    
    func searchMovies(_ keyword: String, _ completion: @escaping (_ result: MoviesListViewModel) -> Void){
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword"
        let defaultResult = MoviesListViewModel(films: [])
            AF.request(urlString,
                       method: .get,
                       parameters: ["keyword": keyword, "page": 1],
                       encoding: URLEncoding.default,
                       headers: ["X-API-KEY": apiKey]
            ).responseJSON(completionHandler: { response in
            
                    switch response.result {
                    case .success:
                        let convertedString = String(data: response.data ?? Data(), encoding: .utf8)
                        let decoder = JSONDecoder()
//                        print(convertedString ?? "")
                        if let jsonData: Data = convertedString?.data(using: .utf8){
                            do{
                                try completion(decoder.decode(MoviesListViewModel.self, from: jsonData))
                            }catch{
                                completion(defaultResult)
                            }

                        }
                        
                    case .failure(_):
                        completion(defaultResult)
                    }
                }
            )
    }
    
    func getTopMovies(_ completion: @escaping (_ result: MoviesListViewModel) -> Void){
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.2/films/top"
        let defaultResult = MoviesListViewModel(films: [])
            AF.request(urlString,
                       method: .get,
                       parameters: ["type": "TOP_100_POPULAR_FILMS"],
                       encoding: URLEncoding.default,
                       headers: ["X-API-KEY": apiKey]
            ).responseJSON(completionHandler: { response in
            
                    switch response.result {
                    case .success:
                        let convertedString = String(data: response.data ?? Data(), encoding: .utf8)
                        let decoder = JSONDecoder()
//                        print(convertedString ?? "")
                        if let jsonData: Data = convertedString?.data(using: .utf8){
                            do{
                                try completion(decoder.decode(MoviesListViewModel.self, from: jsonData))
                            }catch{
                                completion(defaultResult)
                            }

                        }
                        
                    case .failure(_):
                        completion(defaultResult)
                    }
                }
            )
    }
    
    func getMovieById(_ id: Int, _ completion: @escaping (_ result: MovieViewModel?,_ err: Bool) -> Void){
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.2/films/\(id)"
            AF.request(urlString,
                       method: .get,
                       parameters: ["type": "TOP_100_POPULAR_FILMS"],
                       encoding: URLEncoding.default,
                       headers: ["X-API-KEY": apiKey]
            ).responseJSON(completionHandler: { response in
            
                    switch response.result {
                    case .success:
                        let convertedString = String(data: response.data ?? Data(), encoding: .utf8)
                        let decoder = JSONDecoder()
                        print(convertedString ?? "")
                        if let jsonData: Data = convertedString?.data(using: .utf8){
                            do{
                                try completion(decoder.decode(MovieViewModel.self, from: jsonData), false)
                            }catch{
                                completion(nil, true)
                            }

                        }
                        
                    case .failure(_):
                        completion(nil, true)
                    }
                }
            )
    }
}
