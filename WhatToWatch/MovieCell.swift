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
    
    private lazy var posterView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
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
        posterView.image = errorImage
        label.text = nil
    }

    func configure(_ model: ViewModel) {
        if let image = model.moviePoster {
            posterView.image = image
        }
        else{
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        }
        label.text = model.movieTitle
    }
    
    func posterDidLoad(image: UIImage){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        posterView.image = image
    }
    
    // MARK: - Private Methods
    private func setupView(){
        contentView.addSubview(posterView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(label)
        activityIndicator.isHidden = true
    }
    
    private func setupConstraints() {
        posterView.translatesAutoresizingMaskIntoConstraints = false
        posterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        posterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        posterView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        posterView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: posterView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: posterView.centerYAnchor).isActive = true
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    }
}

