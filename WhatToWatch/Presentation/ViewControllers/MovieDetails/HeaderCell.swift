//
//  PreviewAndRatingsCell.swift
//  WhatToWatch
//
//  Created by Ибрахим on 05.10.2023.
//

import UIKit

final class HeaderCell: UITableViewCell {
    // MARK: - Types
    struct ViewModel {
        let imdbRating: String
        let kpRating: String
        let moviePoster: UIImage?
    }
    
    // MARK: - Constants
    
    // MARK: - Public Properties
    
    // MARK: - IBOutlet
    
    // MARK: - Private Properties
    private lazy var previewImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var kinopoiskRatingLabel: LabelSystem16 = {
        LabelSystem16(labelText: "0.0")
    }()
    
    private lazy var imdbRatingLabel: LabelSystem16 = {
        LabelSystem16(labelText: "0.0")
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController(*)
    
    // MARK: - Public Methods
    func configure(imdbRating: String, kpRating: String) {
        imdbRatingLabel.text = imdbRating
        kinopoiskRatingLabel.text = kpRating
    }
    
    func posterDidLoad(image: UIImage?) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        previewImage.image = image
    }
    
    // MARK: - IBAction
    
    // MARK: - Private Methods
    private func setupView() {
        
        ratingStackView.addArrangedSubview(LabelSystem16(labelText: "Kinopoisk"))
        ratingStackView.addArrangedSubview(kinopoiskRatingLabel)
        ratingStackView.addArrangedSubview(LabelSystem16(labelText: "IMDB"))
        ratingStackView.addArrangedSubview(imdbRatingLabel)
        
        contentView.addSubview(previewImage)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(activityIndicator)
        
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            previewImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            previewImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            previewImage.widthAnchor.constraint(equalToConstant: 187.5),
            previewImage.heightAnchor.constraint(equalToConstant: 250),
            
            ratingStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            ratingStackView.leftAnchor.constraint(equalTo: previewImage.rightAnchor, constant: 16),
            ratingStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            ratingStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
    }
}
