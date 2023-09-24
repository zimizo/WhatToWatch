//
//  NetworkManager.swift
//  m19
//
//  Created by Иван Изюмкин on 11.09.2023.
//

import Alamofire
import UIKit

protocol NetworkManagerProtocol {
    /// Что получает? Что запрашивает? И тдЮ
    func getMovies(for request: String, completion: @escaping (MoviesListViewModel?) -> Void)
    func getImage(for url: String, completion: @escaping (UIImage?) -> Void)
    func getTop100Movies(completion: @escaping (MoviesListViewModel?) -> Void)
    func getMovie(by movieId: Int, completion: @escaping (MovieViewModel?) -> Void)
}

/// Общается с кем? Как? и тд
final class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Constants
    
    private enum Constants {
        static let apiKey = "e49616da-1372-491a-840e-81a87afe3e6e"
    }
    
    // MARK: - Public Methods
    
    func getImage(for url: String, completion: @escaping (UIImage?) -> Void) {
        loadData(url: url, parameters: nil, headers: nil){
            data in guard let imageData = data else {
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
    
    func getMovies(for request: String, completion: @escaping (MoviesListViewModel?) -> Void) {
        let url = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword"
        
        loadData(
            url: url,
            parameters: ["keyword": request, "page": 1],
            headers: ["X-API-KEY": Constants.apiKey]){
                responseData in guard let data = responseData else {
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
    
    func getTop100Movies(completion: @escaping (MoviesListViewModel?) -> Void) {
        let url = "https://kinopoiskapiunofficial.tech/api/v2.2/films/top"
        loadData(
            url: url,
            parameters: ["type": "TOP_100_POPULAR_FILMS"],
            headers: ["X-API-KEY": Constants.apiKey]){
                responseData in guard let data = responseData else {
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
        let url = "https://kinopoiskapiunofficial.tech/api/v2.2/films/\(movieId)"
        loadData(
            url: url,
            parameters: nil,
            headers: ["X-API-KEY": Constants.apiKey]
        ){
            responseData in guard let data = responseData else {
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
    	
