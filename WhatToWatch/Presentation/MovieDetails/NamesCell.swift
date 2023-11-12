//
//  NmaesCell.swift
//  WhatToWatch
//
//  Created by Ибрахим on 03.11.2023.
//

import UIKit

final class NamesCell: UITableViewCell {
    // MARK: - Types
    struct ViewModel {
        let name: String
        let enName: String
    }
    
    // MARK: - Constants
    
    // MARK: - Public Properties
    
    // MARK: - IBOutlet
    
    // MARK: - Private Properties
        private lazy var ruNameLabel: UILabel = {
            var view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.textColor = .black
            view.font = .systemFont(ofSize: 24, weight: .bold)
            view.textAlignment = .center
            view.numberOfLines = 0
            return view
        }()
        private lazy var enNameLabel: UILabel = {
            var view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.textColor = .lightGray
            view.font = .systemFont(ofSize: 16)
            view.textAlignment = .center
            view.numberOfLines = 0
            return view
        }()
    
    private lazy var namesStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .equalCentering
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
    func configure(name: String, enName: String) {
        ruNameLabel.text = name
        enNameLabel.text = enName

    }
    // MARK: - IBAction
    
    // MARK: - Private Methods
    private func setupView() {
        selectionStyle = .none
        namesStackView.addArrangedSubview(ruNameLabel)
        namesStackView.addArrangedSubview(enNameLabel)

        contentView.addSubview(namesStackView)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            namesStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            namesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            namesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            namesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
    }
}
