//
//  DayCell.swift
//  SuperbWeather
//
//  Created by Joao Paulo Aquino on 16/07/20.
//  Copyright © 2020 Joao Paulo Aquino. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func configure(viewModel: DayViewModel) {
        dateLabel.text = viewModel.date
        temperatureLabel.text = viewModel.temperature
        iconImageView.kf.indicatorType = .activity
        iconImageView.kf.setImage(with: viewModel.iconURL)
    }
}
