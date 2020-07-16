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
        fetchCityDetails()
        tableView.tableFooterView = UIView()
    }
    
    func setupCurrentWeather() {
        temperatureLabel.text = cityViewModel.temperature
        descriptionLabel.text = cityViewModel.weatherDescription
        cityLabel.text = cityViewModel.name
        iconImageView.kf.indicatorType = .activity
        iconImageView.kf.setImage(with: cityViewModel.iconURL)
    }
    
    func fetchCityDetails() {
        NetworkManager.fetchForecast(for: cityViewModel.list.id) { [weak self] (forecast) in
            guard let forecast = forecast else {return}
            self?.cityViewModel?.cityWeatherResponse = forecast
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityViewModel.dayViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? DayCell
        let dayViewModel = cityViewModel.dayViewModels[indexPath.row]
        cell?.configure(viewModel: dayViewModel)
        return cell ?? UITableViewCell()
    }
}

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

class DayViewModel {
    
    init(cityWeatherList: CityWeatherList) {
        self.cityWeatherList = cityWeatherList
    }
    
    let cityWeatherList: CityWeatherList
    
    var date: String? {
        return cityWeatherList.dtTxt?.dayOfTheWeek()
    }
    
    var iconURL: URL? {
        guard let iconId = cityWeatherList.weather?.first?.icon else {return nil}
        return URL(string: "http://openweathermap.org/img/w/\(iconId).png")
        
    }
    
    var temperature: String {
        guard let temp = cityWeatherList.main?.temp else {return ""}
        return "\(Int(temp))°"
    }
}

class CityViewModel {
    
    internal init(list: List, cityWeatherResponse: CityWeatherResponse? = nil) {
        self.list = list
        self.cityWeatherResponse = cityWeatherResponse
    }
    
    var list: List
    var cityWeatherResponse: CityWeatherResponse?
    
    var dayViewModels: [DayViewModel] {
        guard let list = cityWeatherResponse?.list else {return []}
        return list.map {DayViewModel(cityWeatherList: $0)}
    }

    var temperature: String {
        let temp = Int(list.main.temp)
        return "\(temp)°"
    }
    
    var weatherDescription: String {
        return list.weather.first?.weatherDescription ?? ""
    }
    
    var name: String {
        return list.name
    }
    
    var cityId: Int {
        return list.id
    }
    
    var iconURL: URL? {
        guard let iconId = list.weather.first?.icon else {return nil}
        return URL(string: "http://openweathermap.org/img/w/\(iconId).png")
    }
  
}
