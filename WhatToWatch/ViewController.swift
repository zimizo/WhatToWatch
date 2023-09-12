//
//  ViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

import UIKit
import SnapKit
import Alamofire


class ViewController: UIViewController {
    
    let cellId = "movieTableItem"
    
    let service = MovieService()
    
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
        tableHeaderLabel.snp.makeConstraints { make in
            make.bottom.equalTo(header.snp.bottom).inset(10)
            make.right.equalTo(header.snp.right).inset(10)
            make.left.equalTo(header.snp.left).inset(10)
        }
        view.tableHeaderView = header
        return view
    }()
    
    private lazy var Cellsd: UITableViewCell = {
        var view = UITableViewCell()
            view.backgroundColor = .black
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(MovieCellView.self, forCellReuseIdentifier: cellId )
        tableView.dataSource = self
        tableView.delegate = self
        
        setupView()
        setupConstraints()
    }

    func setupView(){
        view.addSubview(textField)
        view.addSubview(searchButton)
        view.addSubview(getPopularButton)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            guard let self = self else { return }
            self.service.getTopMovies(self.setStore)
        }
    }
    func setupConstraints(){
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).inset(40)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin).inset(16)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(16)
        }
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20.0)
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
        getPopularButton.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(20.0)
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
        

        tableView.snp.makeConstraints { make in
            make.top.equalTo(getPopularButton.snp.bottom).offset(40)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin).inset(16)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).inset(40)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(tableView.snp.centerX)
            make.centerY.equalTo(tableView.snp.centerY)
        }
    }
    
    var movieStore: MoviesListViewModel = MoviesListViewModel(films: [
//        MovieListItemModel(filmId: 677780, nameRu: "alsdkfjaskdlf", posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/677780.jpg"),
//        MovieListItemModel(filmId: 677780, nameRu: "alsdkfjaskdlf", posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/677780.jpg"),
//        MovieListItemModel(filmId: 677780, nameRu: "alsdkfjaskdlf", posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/677780.jpg"),
//        MovieListItemModel(filmId: 677780, nameRu: "alsdkfjaskdlf", posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/677780.jpg"),
//        MovieListItemModel(filmId: 677780, nameRu: "alsdkfjaskdlf", posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/677780.jpg")
    ])
    private func setStore(store: MoviesListViewModel){
        DispatchQueue.main.async {
            self.movieStore = store
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }

    @objc func onSearchButtonClick(){
        activityIndicator.isHidden = false
        
        tableHeaderLabel.text = "Поиск по запросу: \(textField.text ?? "")"
        
        let searchString = textField.text ?? ""
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            guard let self = self else { return }
            self.service.searchMovies(searchString, self.setStore)
        }
    }
    
    @objc func onGetPopularButtonClick(){
        activityIndicator.isHidden = false
        
        tableHeaderLabel.text = "Популярные фильмы"
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            guard let self = self else { return }
            self.service.getTopMovies(self.setStore)
        }
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieStore.films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MovieCellView
        else {
            return UITableViewCell()
            
        }
        let viewModel = movieStore.films[indexPath.row]
        cell.configure(viewModel)

        return cell
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = movieStore.films[indexPath.row]
        let detailsView = MovieDetailsViewController()
        detailsView.setMovieId(viewModel.filmId)
        self.present(detailsView, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


