//
//  MovieTableView.swift
//  WhatToWatch
//
//  Created by Ибрахим on 26.09.2023.
//

import UIKit

protocol MoviesTableViewDelegate: AnyObject {
    func didTapOnMovieCell(with movieId: Int)
}

final class MoviesTable: UITableView {
    // MARK: - Types
    struct MovieListItem {
        let kinopoiskId: Int
        let title: String?
        let posterUrl: String?
        
        var image: UIImage?
    }
    
    // MARK: - Constants
    private let cellId = "movieTableItem"
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Public Properties
    weak var onCellTapDelegate: MoviesTableViewDelegate?
    
    // MARK: - IBOutlet
    
    // MARK: - Private Properties
    
    private var data = [MovieListItem]()
    private var keyword: String?
    
    // MARK: - Initializers
    init(networkManager: NetworkManagerProtocol = NetworkManager(), frame: CGRect, style: UITableView.Style) {
        self.networkManager = networkManager
        super.init(frame: frame, style: style)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController(*)
    
    // MARK: - Public Methods
    func getTopMovies() {
        networkManager.getTop100Movies(completion: self.dataDidLoad)
    }
    func getMovies(for keyword: String) {
        networkManager.getMovies(for: keyword, completion: self.dataDidLoad)
    }
    
    // MARK: - Private methods
    private func setupView() {
        register(MovieCell.self, forCellReuseIdentifier: cellId )
        dataSource = self
        delegate = self
    }
    
    private func setupConstraints() {}
    
    private func convertDataModelToMovieListItem(_ model: MovieListItemModel) -> MovieListItem {
        MovieListItem(
            kinopoiskId: model.filmId,
            title: model.nameRu,
            posterUrl: model.posterUrl
        )
    }
    
    private func convertMovieListItemToMovieCellViewModel(_ item: MovieListItem) -> MovieCell.ViewModel {
        MovieCell.ViewModel(
            movieTitle: item.title ?? "",
            moviePoster: item.image
        )
    }
}

extension MoviesTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MovieCell
        else {
            return UITableViewCell()
        }

        if data[indexPath.row].image == nil,
           let urlString = data[indexPath.row].posterUrl {
            networkManager.getImage(
                for: urlString
            ) { image in
                guard let image = image else {
                    return
                }
                self.data[indexPath.row].image = image
                cell.posterDidLoad(image: image)
            }
        }
        let viewModel = convertMovieListItemToMovieCellViewModel(data[indexPath.row])
        cell.configure(viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let keyword = keyword, !keyword.isEmpty {
            return "Поиск по запросу: \(keyword)"
        } else {
            return "Популярные фильмы"
        }
    }
    
    private func dataDidLoad(_ data: MoviesListViewModel?) {
        guard let listMovies = data else {
            print("Не удалось получить список фильмов")
            return
        }
        self.data = listMovies.films.map({ self.convertDataModelToMovieListItem($0) })
        reloadData()
//        activityIndicator.stopAnimating()
//        activityIndicator.isHidden = true
    }
}

extension MoviesTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = data[indexPath.row]
        if let delegate = onCellTapDelegate {
            delegate.didTapOnMovieCell(with: viewModel.kinopoiskId)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
