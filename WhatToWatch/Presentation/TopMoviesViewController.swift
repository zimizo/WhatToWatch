//
//  TopFilmsViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 24.09.2023.
//

import UIKit

final class TopMoviesViewController: UIViewController {
    // MARK: - Types
    
    // MARK: - Constants
    
    // MARK: - Public Properties
    
    // MARK: - IBOutlet
    
    // MARK: - Private Properties
    private lazy var moviesTable: MoviesTable = {
        var view = MoviesTable(frame: CGRect.zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onCellTapDelegate = self
        return view
    }()
    
    // MARK: - Initializers
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController(*)
    
    // MARK: - Public Methods
    
    // MARK: - IBAction
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(moviesTable)
        
        moviesTable.getTopMovies()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            moviesTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            moviesTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            moviesTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            moviesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moviesTable.reloadData()
    }
}

extension TopMoviesViewController: MoviesTableViewDelegate {
    func didTapOnMovieCell(with movieId: Int) {
        let detailsView = MovieDetailsViewController(movieId)
        self.present(detailsView, animated: true)
    }
}
