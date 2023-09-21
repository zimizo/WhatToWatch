//
//  ViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

import UIKit
import SnapKit

class MovieCell: UITableViewCell {
    
    struct ViewModel {
        let movieTitle: String
        let moviePoster: UIImage?
    }
    
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
        return label
    }()
    
    private lazy var posterView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(posterView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(label)
        activityIndicator.isHidden = true
        
        setupConstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterView.image = errorImage
        label.text = nil
    }
    
//    func configure(_ vm: MovieListItemModel) {
//        let queue = DispatchQueue.global(qos: .userInitiated)
//
//        queue.async {[weak self] in
//            guard let self = self else {return}
//            if let urlString = vm.posterUrl {
//                self.service.loadImage(urlString: urlString) { image in
//                    DispatchQueue.main.async {
//                        self.posterView.image = image ?? self.errorImage
//                        self.activityIndicator.stopAnimating()
//                        self.activityIndicator.isHidden = true
//                    }
//                }
//            }
//        }
//
//
//        //image.image = UIImage(systemName: "folder") ?? UIImage()
//        label.text = vm.nameRu
//    }
    
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
    
    private func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(posterView.snp.centerX)
            make.centerY.equalTo(posterView.snp.centerY)
        }
        posterView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(75)
            make.leading.equalTo(contentView.snp.leading).inset(16)
            make.top.equalTo(contentView.snp.top).inset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
            //make.bottom.equalTo(contentView.snp.bottom).inset(16)
        }
        label.snp.makeConstraints(){
            make in
            make.centerY.equalTo(posterView.snp.centerY)
            make.left.equalTo(posterView.snp.right).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
        }
    }
}

