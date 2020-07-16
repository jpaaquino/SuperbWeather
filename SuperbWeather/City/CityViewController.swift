//
//  CityViewController.swift
//  SuperbWeather
//
//  Created by Joao Paulo Aquino on 14/07/20.
//  Copyright © 2020 Joao Paulo Aquino. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var cityViewModel: CityViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCurrentWeather()
        fetchCity()
        tableView.tableFooterView = UIView()
    }
    
    func setupCurrentWeather() {
        temperatureLabel.text = cityViewModel.temperature
        descriptionLabel.text = cityViewModel.weatherDescription
        cityLabel.text = cityViewModel.name
        iconImageView.kf.indicatorType = .activity
        iconImageView.kf.setImage(with: cityViewModel.iconURL)
    }
    
    func fetchCity() {
        
        cityViewModel.fetchDailyForecast { [weak self] _ in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityViewModel.dayViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? DayCell else {return UITableViewCell()}
        let dayViewModel = cityViewModel.dayViewModels[indexPath.row]
        cell.configure(viewModel: dayViewModel)
        return cell
    }
}
