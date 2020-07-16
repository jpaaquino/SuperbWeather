//
//  ListTableViewCell.swift
//  SuperbWeather
//
//  Created by Joao Paulo Aquino on 16/07/20.
//  Copyright © 2020 Joao Paulo Aquino. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func configure(with viewModel: CityCellViewModel) {
        nameLabel.text = viewModel.name
        temperatureLabel.text = viewModel.temperature
        iconImageView.kf.indicatorType = .activity
        iconImageView.kf.setImage(with: viewModel.iconURL)
    }
}
