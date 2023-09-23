//
//  ViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

import UIKit

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
        return view
    }()

    private lazy var searchButton: UIButton = {
        var view = UIButton(configuration: .filled())
        view.setTitle("Поиск", for: .normal)
        view.addTarget(self, action:#selector(self.onSearchButtonClick), for: .touchUpInside)
        return view
    }()
    
    private lazy var getPopularButton: UIButton = {
        var view = UIButton(configuration: .filled())
        view.setTitle("Популярные фильмы", for: .normal)
        view.addTarget(self, action:#selector(self.onGetPopularButtonClick), for: .touchUpInside)
        return view
    }()
    
    private lazy var textField: UITextField = {
        var view = UITextField()
        view.placeholder = "Введите текст"
        view.borderStyle = .roundedRect
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private lazy var tableHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Популярные фильмы"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray2
        return label
    }()
    
    private lazy var tableView: UITableView = {
        var view = UITableView(frame: CGRect.zero, style: .grouped)
        view.backgroundColor = .white
        let header = UITableViewHeaderFooterView()
        header.contentView.addSubview(tableHeaderLabel)
        header.backgroundColor = .white
        tableHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10).isActive = true
        tableHeaderLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant:  -10).isActive = true
        tableHeaderLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 10).isActive = true

        view.tableHeaderView = header
        return view
    }()
    
    private lazy var Cellsd: UITableViewCell = {
        var view = UITableViewCell()
            view.backgroundColor = .black
        return view
    }()
    
    private var data = [MovieListItem]()

    // MARK: - Initializers
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
        self.networkManager.getTop100Movies(completion: dataDidLoad)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IBAction
    
    @objc private func onSearchButtonClick(){
        activityIndicator.isHidden = false
        
        tableHeaderLabel.text = "Поиск по запросу: \(textField.text ?? "")"
        
        let searchString = textField.text ?? ""
        networkManager.getMovies(for: searchString, completion: dataDidLoad)
    }
    
    @objc private func onGetPopularButtonClick(){
        activityIndicator.isHidden = false
        
        tableHeaderLabel.text = "Популярные фильмы"
        networkManager.getTop100Movies(completion: dataDidLoad)
    }

    // MARK: - Private Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(MovieCell.self, forCellReuseIdentifier: cellId )
        tableView.dataSource = self
        tableView.delegate = self
        setupView()
        setupConstraints()
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


    private func setupView(){
        view.addSubview(textField)
        view.addSubview(searchButton)
        view.addSubview(getPopularButton)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    private func setupConstraints(){

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16).isActive = true
        
        getPopularButton.translatesAutoresizingMaskIntoConstraints = false
        getPopularButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getPopularButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 16).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: getPopularButton.bottomAnchor, constant: 40).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
    }
    
    private func dataDidLoad(_ data: MoviesListViewModel?){
        if let listMovies = data {
            self.data = listMovies.films.map({ self.convertDataModelToMovieListItem($0) })
        } else {
            print("Не удалось получить список фильмов")
        }
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
}

extension MoviesListController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = data[indexPath.row]
        let detailsView = MovieDetailsViewController(viewModel.kinopoiskId)
        self.present(detailsView, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
