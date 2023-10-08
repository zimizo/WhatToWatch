//
//  MovieDetailsViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

import UIKit

final class MovieDetailsViewController: UITableViewController {
    
    // MARK: - Constants
    private let movieId: Int
    
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Private Properties
    private var cells = [UITableViewCell]()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    /// Обновляет UI после получения данных с сервера.
    private func dataDidLoad(_ data: MovieViewModel?) {
        if let vm = data {
            loadContentIndicator.stopAnimating()
            loadContentIndicator.isHidden = true
            
            let headerCell = HeaderCell()
            headerCell.configure(imdbRating: "\(vm.ratingImdb ?? 0.0)", kpRating: "\(vm.ratingKinopoisk ?? 0.0)")
            if let urlString = vm.posterUrl {
                networkManager.getImage(for: urlString, completion: headerCell.posterDidLoad)
            }
            cells.append(headerCell)
            
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
    
    private func setupView() {
        view.addSubview(loadContentIndicator)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    private func setupConstraits() {
        NSLayoutConstraint.activate([
            loadContentIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadContentIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
