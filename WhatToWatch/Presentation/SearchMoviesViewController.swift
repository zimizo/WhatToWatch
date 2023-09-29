//
//  ViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

import UIKit

/// Контроллер для отображения списка топ 100 фильмов.
final class SearchMoviesViewController: UIViewController {
    // MARK: - Constants
    private let cellId = "movieTableItem"
    private let networkManager: NetworkManagerProtocol

    // MARK: - Private Properties
    private lazy var searchButton: UIButton = {
        var view = UIButton(configuration: .filled())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Поиск", for: .normal)
        view.addTarget(
            self,
            action: #selector(self.onSearchButtonClick),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var textField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите текст"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.lightGray.cgColor
        return textField
    }()
    
    private lazy var tableView: MoviesTable = {
        var view = MoviesTable(frame: CGRect.zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.onCellTapDelegate = self
        return view
    }()
    
    private lazy var searchController: UISearchController = {
        var controller = UISearchController()
        controller.searchResultsUpdater = self
        return controller
    }()
    
    private var searchTimer: Timer?
    // MARK: - Initializers
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    // MARK: - Actions
    
    @objc private func onSearchButtonClick() {
        let searchString = textField.text ?? ""
        tableView.getMovies(for: searchString)
    }

    // MARK: - Private Methods

    private func setupView() {
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
//        view.addSubview(textField)
//        view.addSubview(searchButton)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
//            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
//            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//
//            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            searchButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            tableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 40),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

extension SearchMoviesViewController: MoviesTableViewDelegate {
    func didTapOnMovieCell(with movieId: Int) {
        let detailsView = MovieDetailsViewController(movieId)
        self.present(detailsView, animated: true)
    }
}

extension SearchMoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in 
            self.tableView.getMovies(for: searchString)
        })

    }
}
