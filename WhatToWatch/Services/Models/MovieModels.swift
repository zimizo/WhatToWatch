//
//  ViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

import Foundation
/// Модель фильма для экрана details
struct MovieViewModel: Codable {
    let id: Int
    let name: String?
    let enName: String?
    let poster: Poster?
    let rating: Rating?
    let year: Int?
    let movieLength: Int?
    let description: String?
}

/// Модель списка фильмов для списка
struct MoviesListViewModel: Codable {
    var docs: [MovieListSearchModel] = Array()
}

/// Модель фильма для элемента в списке
struct MovieListSearchModel: Codable {
    let id: Int
    let name: String?
    let poster: Poster?
}

struct Rating: Codable {
    let kp: Double?
    let imdb: Double?
}

struct Poster: Codable {
    let url: String?
    let previewUrl: String?
}
