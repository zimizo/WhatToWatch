//
//  NetworkManager.swift
//  WhatToWatch
//
//  Created by Ибрахим on 11.09.2023.
//

import Alamofire
import UIKit

protocol NetworkManagerProtocol {
    /// Запрашивает даные для списка при поиске фильмов по названию и фильтрам
    /// Передает в замыкание MoviesListViewModel
    func getMovies(for request: String, filtres: [String: Any], completion: @escaping (MoviesListViewModel?) -> Void)
    /// Запрашивает каринку по url
    /// Передает в замыкание UIImage
    func getImage(for url: String, completion: @escaping (UIImage?) -> Void)
    /// Запрашивает даные для списка популярных фильмов
    /// Передает в замыкание MoviesListViewModel
    func getTop200Movies(completion: @escaping (MoviesListViewModel?) -> Void)
    /// Запрашивает даные фильма по id
    /// Передает в замыкание MovieViewModel
    func getMovie(by movieId: Int, completion: @escaping (MovieViewModel?) -> Void)
}

/// Запрашивает данные о фильмах с https://kinopoiskapiunofficial.tech
/// Использует Alamofire
final class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Constants
    
    private enum Constants {
        static let apiKey = "AE079VA-QECM7AJ-M9XSGD8-DAFS6PD"
    }
    
    // MARK: - Public Methods
    
    func getImage(for url: String, completion: @escaping (UIImage?) -> Void) {
        loadData(url: url, parameters: nil, headers: nil) { data in
            guard let imageData = data else {
                print("NetworkManager.getImage: Данные не обнаружены.")
                completion(nil)
                return
            }
            
            guard let image = UIImage(data: imageData) else {
                print("NetworkManager.getImage: Не удалось получить изображение из данных.")
                completion(nil)
                return
            }
            
            completion(image)
        }
    }
    
    func getMovies(for request: String, filtres: [String: Any], completion: @escaping (MoviesListViewModel?) -> Void) {
        let url = "https://api.kinopoisk.dev/v1.3/movie"
        var parameters: [String: Any] = [
            "selectFields": [
                "id",
                "name",
                "enName",
                "poster",
                "rating",
                "year",
                "movieLength",
                "description"
            ],
            "name": request,
            "limit": 200
        ]

        filtres.forEach { key, value in
            parameters[key] = value
        }
        
        loadData(
            url: url,
            parameters: parameters,
            headers: ["X-API-KEY": Constants.apiKey]) { responseData in
            guard let data = responseData else {
                print("NetworkManager.getMovies: Данные не обнаружены.")
                completion(nil)
                return
            }
            
            do {
                try completion(JSONDecoder().decode(MoviesListViewModel.self, from: data))
            } catch {
                print("NetworkManager.getMovies: Не получилось конвертировать данные в модель.")
                completion(nil)
            }
        }
    }
    
    func getTop200Movies(completion: @escaping (MoviesListViewModel?) -> Void) {
        let url = "https://api.kinopoisk.dev/v1.3/movie"
        loadData(
            url: url,
            parameters: [
                "limit": 200,
                "top250": "!null",
                "sortField": ["year", "rating.kp"],
                "sortType": [-1, -1],
                "type": "movie"
            ],
            headers: ["X-API-KEY": Constants.apiKey]) { responseData in
                
            guard let data = responseData else {
                print("NetworkManager.getTop100Movies: Данные не обнаружены.")
                completion(nil)
                return
            }
                
            do {
                try completion(JSONDecoder().decode(MoviesListViewModel.self, from: data))
            } catch {
                print("NetworkManager.getTop100Movies: Не получилось конвертировать данные в модель.")
                completion(nil)
            }
        }
    }
    
    func getMovie(by movieId: Int, completion: @escaping (MovieViewModel?) -> Void) {
        let url = "https://api.kinopoisk.dev/v1.3/movie/\(movieId)"
        loadData(
            url: url,
            parameters: nil,
            headers: ["X-API-KEY": Constants.apiKey]) { responseData in
            guard let data = responseData else {
                print("NetworkManager.getMovie: Данные не обнаружены.")
                completion(nil)
                return
            }
            
            do {
                try completion(JSONDecoder().decode(MovieViewModel.self, from: data))
            } catch {
                print("NetworkManager.getMovie: Не получилось конвертировать данные в модель.")
                completion(nil)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadData(
        url: String,
        parameters: Parameters?,
        headers: HTTPHeaders?,
        completion: @escaping (Data?) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            AF.request(
                url,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: headers
            ).response(completionHandler: { response in
                if let error = response.error {
                    print(error.localizedDescription)
                    completion(nil)
                    return
                }
                
                guard let data = response.data else {
                    print("Данные не обнаружены.")
                    completion(nil)
                    return
                }
                DispatchQueue.main.async {
                    completion(data)
                }
            })
        }
    }
}
    	
