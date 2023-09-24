//
//  ViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

import UIKit

/// Контроллер для отображения списка топ 100 фильмов.
final class MoviesListController: UIViewController {
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

    // MARK: - Private Properties
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 140, height: 140))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var searchButton: UIButton = {
        var view = UIButton(configuration: .filled())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Поиск", for: .normal)
        view.addTarget(self, action:#selector(self.onSearchButtonClick), for: .touchUpInside)
        return view
    }()
    
    private lazy var getPopularButton: UIButton = {
        var view = UIButton(configuration: .filled())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Популярные фильмы", for: .normal)
        view.addTarget(self, action:#selector(self.onGetPopularButtonClick), for: .touchUpInside)
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
    
    private lazy var tableView: UITableView = {
        var view = UITableView(frame: CGRect.zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private var data = [MovieListItem]()

    // MARK: - Initializers
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
        preloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(MovieCell.self, forCellReuseIdentifier: cellId )
        tableView.dataSource = self
        tableView.delegate = self
        setupView()
        setupConstraints()
    }

    // MARK: - Actions
    
    @objc private func onSearchButtonClick() {
        activityIndicator.isHidden = false
        
        let searchString = textField.text ?? ""
        networkManager.getMovies(for: searchString, completion: dataDidLoad)
    }
    
    @objc private func onGetPopularButtonClick() {
        activityIndicator.isHidden = false
        textField.text = nil
        networkManager.getTop100Movies(completion: dataDidLoad)
    }

    // MARK: - Private Methods
    
    private func preloadData() {
        activityIndicator.startAnimating()
        networkManager.getTop100Movies(completion: dataDidLoad)
    }
    
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

    private func setupView() {
        view.addSubview(textField)
        view.addSubview(searchButton)
        view.addSubview(getPopularButton)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            
            getPopularButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getPopularButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 16),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: getPopularButton.bottomAnchor, constant: 40),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    private func dataDidLoad(_ data: MoviesListViewModel?) {
        guard let listMovies = data else {
            print("Не удалось получить список фильмов")
            return
        }
        self.data = listMovies.films.map({ self.convertDataModelToMovieListItem($0) })
        tableView.reloadData()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}

extension MoviesListController: UITableViewDataSource {
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
        if let filmTitle = textField.text, !filmTitle.isEmpty {
            return "Поиск по запросу: \(filmTitle)"
        } else {
            return "Популярные фильмы"
        }
    }
}

extension MoviesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = data[indexPath.row]
        let detailsView = MovieDetailsViewController(viewModel.kinopoiskId)
        self.present(detailsView, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
