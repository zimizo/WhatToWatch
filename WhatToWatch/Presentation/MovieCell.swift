//
//  ViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

import UIKit

final class MovieCell: UITableViewCell {
    // MARK: - Types
    struct ViewModel {
        let movieTitle: String
        let moviePoster: UIImage?
    }
    
    // MARK: - Private Properties
    
    private lazy var errorImage: UIImage = {
        UIImage()
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 50, height: 50))
        view.isHidden = true
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
//        image.clipsToBounds = true
        return imageView
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
    
    // MARK: - Public Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = errorImage
        label.text = nil
    }

    func configure(_ model: ViewModel) {
        if let image = model.moviePoster {
            posterImageView.image = image
        } else {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        }
        label.text = model.movieTitle
    }
    
    func posterDidLoad(image: UIImage) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        posterImageView.image = image
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(label)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.widthAnchor.constraint(equalToConstant: 75),
//            posterImageView.heightAnchor.constraint(equalToConstant: 100),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    }
}
