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
    private var title: String?
    
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
        title = "Популярные фильмы"
        networkManager.getTop200Movies(completion: self.dataDidLoad)
    }
    func getMovies(for keyword: String, filtres: [String: Any]) {
        if keyword.isEmpty {
            title = "Введите запрос"
        } else {
            self.title = "Поиск по запросу: \(keyword)"
        }
        networkManager.getMovies(for: keyword, filtres: filtres, completion: self.dataDidLoad)
    }
    
    // MARK: - Private methods
    private func setupView() {
        register(MovieCell.self, forCellReuseIdentifier: cellId )
        dataSource = self
        delegate = self
    }
    
    private func setupConstraints() {}
    
    private func convertDataModelToMovieListItem(_ model: MovieListSearchModel) -> MovieListItem {
        MovieListItem(
            kinopoiskId: model.id,
            title: model.name,
            posterUrl: model.poster?.url
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
        return title
    }
    
    private func dataDidLoad(_ data: MoviesListViewModel?) {
        guard let listMovies = data else {
            print("Не удалось получить список фильмов")
            return
        }
        self.data = listMovies.docs.map({ self.convertDataModelToMovieListItem($0) })
        reloadData()
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
