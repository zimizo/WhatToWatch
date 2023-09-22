//
//  ViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

import UIKit
class MovieDetailsViewController: UIViewController{
    // MARK: - Constants
    private let movieId: Int
    
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Private Properties
    
    private lazy var scrollView: UIScrollView = {
        UIScrollView()
    }()
    
    private lazy var errorImage: UIImage = {
        UIImage().withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
    }()
    
    private lazy var previewImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    private lazy var kinopoiskLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "Kinopoisk"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    private lazy var kinopoiskRatingLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    private lazy var imdbLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "IMDB"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    private lazy var imdbRatingLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    private lazy var ruNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var originalNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    private lazy var yearLabel: UILabel = {
        var label = UILabel()
        label.textColor = .lightGray
        label.text = "Год производства:"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private lazy var yearValueLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private lazy var filmLengthLabel: UILabel = {
        var label = UILabel()
        label.textColor = .lightGray
        label.text = "Продолжительность:"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private lazy var filmLengthValueLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private lazy var loadContentIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        return view
    }()
    
    private lazy var loadImageIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        return view
    }()
    
    // MARK: - Initializers
    init(_ movieId: Int, networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLoadContentIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func setupLoadContentIndicator() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
//        scrollView.addSubview(loadContentIndicator)
//        loadContentIndicator.startAnimating()
//        loadContentIndicator.translatesAutoresizingMaskIntoConstraints = false
//
//        loadImageIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        loadImageIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func dataDidLoad(_ data: MovieViewModel?) -> Void {

        if let vm = data {
                
                loadContentIndicator.stopAnimating()
                loadContentIndicator.isHidden = true
                
                setupView()
                setupConstraits()
                
                imdbRatingLabel.text = "\(vm.ratingImdb ?? 0.0)"
                kinopoiskRatingLabel.text = "\(vm.ratingKinopoisk ?? 0.0)"
                ruNameLabel.text = vm.nameRu
                originalNameLabel.text = vm.nameOriginal
                descriptionLabel.text = vm.description ?? ""
                yearValueLabel.text = "\(vm.year ?? 0)"
                filmLengthValueLabel.text = "\(vm.filmLength ?? 0) мин."
                
                if let urlString = vm.posterUrl {
                    networkManager.getImage(for: urlString) { image in
                            self.previewImage.image = image ?? self.errorImage
                            self.loadImageIndicator.stopAnimating()
                            self.loadImageIndicator.isHidden = true
                    }
                }
            }
            else{
                self.loadContentIndicator.stopAnimating()
                self.loadContentIndicator.isHidden = true
                
                let errorImageView = UIImageView()
                errorImageView.image = self.errorImage
                self.view.addSubview(errorImageView)
                errorImageView.snp.makeConstraints { make in
                    make.height.equalTo(250)
                    make.width.equalTo(250)
                    make.centerY.equalTo(self.view.snp.centerY)
                    make.centerX.equalTo(self.view.snp.centerX)
                }
            }
        }

    
    private func loadData(){
        networkManager.getMovie(by: movieId, completion: dataDidLoad)
    }
    
    private func setupView(){
        scrollView.addSubview(previewImage)
        scrollView.addSubview(previewImage)
        scrollView.addSubview(kinopoiskLabel)
        scrollView.addSubview(kinopoiskRatingLabel)
        scrollView.addSubview(imdbLabel)
        scrollView.addSubview(imdbRatingLabel)
        scrollView.addSubview(ruNameLabel)
        scrollView.addSubview(originalNameLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(yearLabel)
        scrollView.addSubview(yearValueLabel)
        scrollView.addSubview(filmLengthLabel)
        scrollView.addSubview(filmLengthValueLabel)
        scrollView.addSubview(loadImageIndicator)
        loadImageIndicator.startAnimating()
    }
    
    private func setupConstraits(){
        
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        previewImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        previewImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        previewImage.widthAnchor.constraint(equalToConstant: 187.5).isActive = true
        previewImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
    
        
        loadImageIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadImageIndicator.centerXAnchor.constraint(equalTo: previewImage.centerXAnchor).isActive = true
        loadImageIndicator.centerYAnchor.constraint(equalTo: previewImage.centerYAnchor).isActive = true
        
        kinopoiskLabel.translatesAutoresizingMaskIntoConstraints = false
        kinopoiskLabel.topAnchor.constraint(equalTo: previewImage.topAnchor, constant: 10).isActive = true
        kinopoiskLabel.leftAnchor.constraint(equalTo: previewImage.rightAnchor, constant: 16).isActive = true
        kinopoiskLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        kinopoiskRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        kinopoiskRatingLabel.topAnchor.constraint(equalTo: kinopoiskLabel.bottomAnchor, constant: 10).isActive = true
        kinopoiskRatingLabel.leftAnchor.constraint(equalTo: previewImage.rightAnchor, constant: 16).isActive = true
        kinopoiskRatingLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        imdbLabel.translatesAutoresizingMaskIntoConstraints = false
        imdbLabel.topAnchor.constraint(equalTo: kinopoiskRatingLabel.bottomAnchor, constant: 10).isActive = true
        imdbLabel.leftAnchor.constraint(equalTo: previewImage.rightAnchor, constant: 16).isActive = true
        imdbLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        imdbRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        imdbRatingLabel.topAnchor.constraint(equalTo: imdbLabel.bottomAnchor, constant: 10).isActive = true
        imdbRatingLabel.leftAnchor.constraint(equalTo: previewImage.rightAnchor, constant: 16).isActive = true
        imdbRatingLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        ruNameLabel.translatesAutoresizingMaskIntoConstraints = false
        ruNameLabel.topAnchor.constraint(equalTo: previewImage.bottomAnchor, constant: 20).isActive = true
        ruNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        ruNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        originalNameLabel.translatesAutoresizingMaskIntoConstraints = false
        originalNameLabel.topAnchor.constraint(equalTo: ruNameLabel.bottomAnchor, constant: 10).isActive = true
        originalNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        originalNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: originalNameLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
        yearLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        yearLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        yearValueLabel.translatesAutoresizingMaskIntoConstraints = false
        yearValueLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 10).isActive = true
        yearValueLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        yearValueLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        filmLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        filmLengthLabel.topAnchor.constraint(equalTo: yearValueLabel.bottomAnchor, constant: 20).isActive = true
        filmLengthLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        filmLengthLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        filmLengthValueLabel.translatesAutoresizingMaskIntoConstraints = false
        filmLengthValueLabel.topAnchor.constraint(equalTo: filmLengthLabel.bottomAnchor, constant: 10).isActive = true
        filmLengthValueLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        filmLengthValueLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        filmLengthValueLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
    }
}

//var faceViewModel = MovieViewModel(
//    kinopoiskId: 123,
//    nameRu: "Ровер",
//    nameOriginal: "The Rover",
//    posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/677780.jpg",
//    ratingKinopoisk: 6.2,
//    ratingImdb: 6.2,
//    year: 2012,
//    filmLength: 114,
//    description: "Через 10 лет после глобального экономического коллапса закаленный герой-одиночка преследует банду, угнавшую его автомобиль.")
