//
//  characteristicCell.swift
//  WhatToWatch
//
//  Created by Ибрахим on 03.11.2023.
//

import UIKit

final class CharacteristicCell: UITableViewCell {
    // MARK: - Types
    struct ViewModel {
        let name: String
        let enName: String
    }
    
    // MARK: - Constants
    
    // MARK: - Public Properties
    
    // MARK: - IBOutlet
    
    // MARK: - Private Properties
    private lazy var nameLabel: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    private lazy var valueLabel: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
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
    func configure(name: String, value: String) {
        nameLabel.text = name
        valueLabel.text = value

    }
    // MARK: - IBAction
    
    // MARK: - Private Methods
    private func setupView() {
        selectionStyle = .none
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(valueLabel)

        contentView.addSubview(stackView)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
    }
}
