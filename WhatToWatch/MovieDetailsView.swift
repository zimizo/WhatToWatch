//
//  ViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

import UIKit
class MovieDetailsViewController: UIViewController{
    
    private lazy var errorImage: UIImage = {
        UIImage().withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
    }()
    
    private lazy var previewImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
//        image.backgroundColor = .systemGray5
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
        return label
    }()
    private lazy var originalNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
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
        let view = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 50, height: 50))
        return view
    }()
    
    private lazy var loadImageIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 50, height: 50))
        return view
    }()
    
    private var movieId: Int? = nil

    private var viewModel: MovieViewModel? = nil
    
    let service = MovieService()




    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(loadContentIndicator)
        loadContentIndicator.startAnimating()
        loadContentIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    private func dataDidLoad(_ result: MovieViewModel?, _ err: Bool) -> Void {
        DispatchQueue.main.async {
            if(!err){
                self.viewModel = result
                self.loadContentIndicator.stopAnimating()
                self.loadContentIndicator.isHidden = true
                self.setupView()
                self.setupConstraits()
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
    }

    
    func loadData(){
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            guard let self = self else { return }
            self.service.getMovieById(self.movieId!, self.dataDidLoad)
        }
    }
    func setupView(){
        configureView(viewModel!)
        view.addSubview(previewImage)
        view.addSubview(previewImage)
        view.addSubview(kinopoiskLabel)
        view.addSubview(kinopoiskRatingLabel)
        view.addSubview(imdbLabel)
        view.addSubview(imdbRatingLabel)
        view.addSubview(ruNameLabel)
        view.addSubview(originalNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(yearLabel)
        view.addSubview(yearValueLabel)
        view.addSubview(filmLengthLabel)
        view.addSubview(filmLengthValueLabel)
        view.addSubview(loadImageIndicator)
        loadImageIndicator.startAnimating()
    }
    func setupConstraits(){

        previewImage.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.width.equalTo(187.5)
            make.height.equalTo(250)
        }
        
        loadImageIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(previewImage.snp.centerY)
            make.centerX.equalTo(previewImage.snp.centerX)
        }

        kinopoiskLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).inset(10)
            make.left.equalTo(previewImage.snp.right).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(16)
        }

        kinopoiskRatingLabel.snp.makeConstraints { make in
            make.top.equalTo(kinopoiskLabel.snp.bottom).offset(16)
            make.left.equalTo(previewImage.snp.right).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(16)
        }

        imdbLabel.snp.makeConstraints { make in
            make.top.equalTo(kinopoiskRatingLabel.snp.bottom).offset(16)
            make.left.equalTo(previewImage.snp.right).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(16)
        }

        imdbRatingLabel.snp.makeConstraints { make in
            make.top.equalTo(imdbLabel.snp.bottom).offset(16)
            make.left.equalTo(previewImage.snp.right).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(16)
        }

        ruNameLabel.snp.makeConstraints { make in
            make.top.equalTo(previewImage.snp.bottom).offset(30)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(16)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin).inset(16)
        }

        originalNameLabel.snp.makeConstraints { make in
            make.top.equalTo(ruNameLabel.snp.bottom).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(16)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin).inset(16)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(originalNameLabel.snp.bottom).offset(30)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(16)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin).inset(16)
        }

        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(16)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin).inset(16)
        }

        yearValueLabel.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(16)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin).inset(16)
        }

        filmLengthLabel.snp.makeConstraints { make in
            make.top.equalTo(yearValueLabel.snp.bottom).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(16)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin).inset(16)
        }

        filmLengthValueLabel.snp.makeConstraints { make in
            make.top.equalTo(filmLengthLabel.snp.bottom).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).inset(16)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin).inset(16)
        }
    }
    
    func configureView(_ vm: MovieViewModel){
       
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async {[weak self] in
            guard let self = self else {return}
            
            let uiimage = self.service.loadImage(urlString: vm.posterUrl ?? "") ?? self.errorImage
            
            
            DispatchQueue.main.async {
                self.previewImage.image = uiimage
                self.loadImageIndicator.stopAnimating()
                self.loadImageIndicator.isHidden = true
            }
        }
        
        imdbRatingLabel.text = "\(vm.ratingImdb ?? 0.0)"
        kinopoiskRatingLabel.text = "\(vm.ratingKinopoisk ?? 0.0)"
        ruNameLabel.text = vm.nameRu
        originalNameLabel.text = vm.nameOriginal
        descriptionLabel.text = vm.description
        yearValueLabel.text = "\(vm.year ?? 0)"
        filmLengthValueLabel.text = "\(vm.filmLength ?? 0) мин."
    }
    
    func setMovieId(_ id: Int){
        movieId = id
    }
}

var faceViewModel = MovieViewModel(kinopoiskId: 123, nameRu: "Ровер", nameOriginal: "The Rover", posterUrl: "https://kinopoiskapiunofficial.tech/images/posters/kp/677780.jpg", ratingKinopoisk: 6.2, ratingImdb: 6.2, year: 2012, filmLength: 114, description: "Через 10 лет после глобального экономического коллапса закаленный герой-одиночка преследует банду, угнавшую его автомобиль.")
