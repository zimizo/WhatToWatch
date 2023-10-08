//
//  FiltersViewController.swift
//  WhatToWatch
//
//  Created by Ибрахим on 01.10.2023.
//

import Foundation
import TTRangeSlider
import UIKit

final class FiltersViewController: UIViewController {
    // MARK: - Types
    
    // MARK: - Constants
    let ratingSliderId = "rating"
    let yearSliderId = "year"
    
    // MARK: - Public Properties
    var movieMinYear: Int = 1900
    var movieMaxYear: Int = Calendar.current.component(.year, from: Date.now)
    
    var movieMaxRating: Float = 10.0
    var movieMinRating: Float = 0.0
    
    var filtres: [String: Any] {
        [
            "ratingFrom": movieMinRating,
            "ratingTo": movieMaxRating,
            "yearFrom": movieMinYear,
            "yearTo": movieMaxYear
        ]
    }
    
    // MARK: - IBOutlet
    
    // MARK: - Private Properties
    private lazy var yearSlider: RangeSlider = {
        let view = RangeSlider(id: yearSliderId, maxVal: Float(movieMaxYear), minVal: Float(movieMinYear), step: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rangeSliderDelegate = self
        view.numberFormatterOverride = NumberFormatter()
        return view
    }()
    private lazy var ratingSlider: RangeSlider = {
        let view = RangeSlider(id: ratingSliderId, maxVal: movieMaxRating, minVal: movieMinRating, step: 0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rangeSliderDelegate = self
        
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.numberStyle = .decimal
        view.numberFormatterOverride = formatter
        
        return view
    }()
    
    // MARK: - Initializers
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    // MARK: - UIViewController(*)
    
    // MARK: - Public Methods
    
    // MARK: - IBAction
    
    // MARK: - Private Methods
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(yearSlider)
        view.addSubview(ratingSlider)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            yearSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            yearSlider.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            yearSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            ratingSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ratingSlider.topAnchor.constraint(equalTo: yearSlider.bottomAnchor, constant: 16),
            ratingSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

extension FiltersViewController: RangeSliderDelegate {
    func sliderDidChanged(id: String, selectedMinimum: Float, selectedMaximum: Float) {
        let maximum = selectedMaximum.rounded(.toNearestOrAwayFromZero)
        let minimum = selectedMinimum.rounded(.toNearestOrAwayFromZero)
        switch id {
        case yearSliderId:
            self.movieMaxYear = Int(maximum)
            self.movieMinYear = Int(minimum)
        case ratingSliderId:
            self.movieMaxRating = maximum
            self.movieMinRating = minimum
        default:
            return
        }
        print(maximum)
        print(minimum)
    }
}
