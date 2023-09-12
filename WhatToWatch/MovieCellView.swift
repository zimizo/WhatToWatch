//
//  ViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 12.09.2023.
//

import UIKit
import SnapKit

class MovieCellView: UITableViewCell{
    
    let service = MovieService()
    
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
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        //        image.backgroundColor = .gray
        return image
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //contentView.addSubview(stackView)
        contentView.addSubview(image)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(label)
        activityIndicator.startAnimating()
        
        setupConstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ vm: MovieListItemModel){
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async {[weak self] in
            guard let self = self else {return}
            
            let uiimage = self.service.loadImage(urlString: vm.posterUrl ?? "") ?? self.errorImage
            DispatchQueue.main.async {
                self.image.image = uiimage
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
        
        
        //image.image = UIImage(systemName: "folder") ?? UIImage()
        label.text = vm.nameRu
    }
    
    private func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(image.snp.centerX)
            make.centerY.equalTo(image.snp.centerY)
        }
        image.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(75)
            make.leading.equalTo(contentView.snp.leading).inset(16)
            make.top.equalTo(contentView.snp.top).inset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
            //make.bottom.equalTo(contentView.snp.bottom).inset(16)
        }
        label.snp.makeConstraints(){
            make in
            make.centerY.equalTo(image.snp.centerY)
            make.left.equalTo(image.snp.right).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
        }
    }
}



