//
//  ViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

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

struct MoviesListViewModel:Codable{
    var films: [MovieListItemModel] = Array()
}

struct MovieListItemModel: Codable {
    let filmId: Int
    let nameRu: String?
    let posterUrl: String?
}

