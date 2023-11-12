//
//  MovieDetailsViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

import UIKit

final class MovieDetailsViewController: UITableViewController {
    
    // MARK: - Constants
    enum MovieDetailsCells: CaseIterable {
        case hederCell
        case namesCell
        case descriptionCell
        case durationCell
        case yearCell
    }
    
    // MARK: - Private Properties
    private let movieId: Int
    private var viewModel: MovieViewModel?
    private let networkManager: NetworkManagerProtocol
    
    private lazy var loadContentIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var erroorImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initializers
    
    init(_ movieId: Int, networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
        
        setupView()
        setupConstraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(loadContentIndicator)
    }
    
    /// Обновляет UI после получения данных с сервера.
    private func dataDidLoad(_ data: MovieViewModel?) {
        if let data = data {
            viewModel = data
            
            self.tableView.reloadData()
            
        } else {
            self.loadContentIndicator.stopAnimating()
            self.loadContentIndicator.isHidden = true
            self.view.addSubview(erroorImage)
            erroorImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            erroorImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        }
    }
    
    /// Загружает данные о текущем фильме.
    private func loadData() {
        networkManager.getMovie(by: movieId, completion: dataDidLoad)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MovieDetailsCells.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let viewModel = viewModel {
            switch MovieDetailsCells.allCases[indexPath.row] {
            case MovieDetailsCells.hederCell:
                let cell = PosterAndRatingCell()
                cell.configure(
                    imdbRating: "\(viewModel.rating?.imdb ?? 0.0)",
                    kpRating: "\(viewModel.rating?.kp ?? 0.0)"
                )

                networkManager.getImage(for: viewModel.poster?.url ?? "", completion: cell.posterDidLoad)
                return cell
            case MovieDetailsCells.namesCell:
                let cell = NamesCell()
                cell.configure(
                    name: viewModel.name ?? "",
                    enName: viewModel.enName ?? ""
                )
                return cell
            case MovieDetailsCells.descriptionCell:
                let cell = DescriptionCell()
                cell.configure(description: viewModel.description ?? "")
                return cell
            case MovieDetailsCells.yearCell:
                if let year = viewModel.year {
                    let cell = CharacteristicCell()
                    cell.configure(name: "Год производства:", value: "\(year)")
                    return cell
                }
            case MovieDetailsCells.durationCell:
                if let value = viewModel.movieLength {
                    let cell = CharacteristicCell()
                    cell.configure(name: "Продолжительность:", value: "\(value) мин.")
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    private func setupConstraits() {
        NSLayoutConstraint.activate([
            loadContentIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadContentIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
