//
//  descriptionCell.swift
//  WhatToWatch
//
//  Created by Ибрахим on 03.11.2023.
//

import UIKit

final class DescriptionCell: UITableViewCell {

    // MARK: - Private Properties
        private lazy var descriptionLabel: UILabel = {
            var view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.textColor = .black
            view.font = .systemFont(ofSize: 16)
            view.numberOfLines = 0
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
    
    // MARK: - Public Methods
    func configure(description: String) {
        descriptionLabel.text = description
    }

    // MARK: - Private Methods
    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
