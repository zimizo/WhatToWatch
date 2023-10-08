//
//  RatingLabel.swift
//  WhatToWatch
//
//  Created by Ибрахим on 05.10.2023.
//

import UIKit

final class LabelSystem16: UILabel {
    init(labelText: String) {
        super.init(frame: CGRect())
        self.textColor = .black
        self.text = labelText
        self.font = .systemFont(ofSize: 16)
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
