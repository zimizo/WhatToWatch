//
//  DoubleSlider.swift
//  WhatToWatch
//
//  Created by Ибрахим on 03.10.2023.
//

import TTRangeSlider

protocol RangeSliderDelegate {
    func sliderDidChanged(id: String, selectedMinimum: Float, selectedMaximum: Float)
}

class RangeSlider: TTRangeSlider {
    // MARK: - Public Properties
    let id: String
    var rangeSliderDelegate: RangeSliderDelegate?
    
    // MARK: - IBOutlet
    
    // MARK: - Private Properties
    
    // MARK: - Initializers
    init(id: String, maxVal: Float, minVal: Float, step: Float) {
        self.id = id
        super.init(frame: CGRect())
        self.maxValue = maxVal
        self.minValue = minVal
        self.step = step
        self.enableStep = true
//        self.numberFormatterOverride = NumberFormatter()
        self.selectedMaximum = self.maxValue
        self.selectedMinimum = self.minValue
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController(*)
    
    // MARK: - Public Methods
    
    // MARK: - IBAction
    
    // MARK: - Private Methods
}

extension RangeSlider: TTRangeSliderDelegate {
    func rangeSlider(
        _ sender: TTRangeSlider!,
        didChangeSelectedMinimumValue selectedMinimum: Float,
        andMaximumValue selectedMaximum: Float) {
        if let delegate = self.rangeSliderDelegate {
            delegate.sliderDidChanged(id: self.id, selectedMinimum: selectedMinimum, selectedMaximum: selectedMaximum)
        }
    }
}
