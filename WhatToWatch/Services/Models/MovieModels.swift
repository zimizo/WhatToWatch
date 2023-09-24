//
//  ViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

// TODO: - Добавить документацию
/// ?
struct MovieViewModel: Codable {
    let kinopoiskId: Int
    let nameRu: String?
    let nameOriginal: String?
    let posterUrl: String?
    let ratingKinopoisk: Double?
    let ratingImdb: Double?
    let year: Int?
    let filmLength: Int?
    let description: String?
}

// TODO: - Добавить документацию
/// ?
struct MoviesListViewModel: Codable {
    var films: [MovieListItemModel] = Array()
}

// TODO: - Добавить документацию
/// ?
struct MovieListItemModel: Codable {
    let filmId: Int
    let nameRu: String?
    let posterUrl: String?
}
