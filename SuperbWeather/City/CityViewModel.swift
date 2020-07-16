//
//  CityViewModel.swift
//  SuperbWeather
//
//  Created by Joao Paulo Aquino on 16/07/20.
//  Copyright © 2020 Joao Paulo Aquino. All rights reserved.
//

import Foundation

class CityViewModel {
    
    internal init(list: List, cityForecast: CityForecast? = nil) {
        self.list = list
        self.cityForecast = cityForecast
    }
    
    var cityForecast: CityForecast?
    
    var list: List
    
    func fetchDailyForecast(completion: @escaping (Bool) -> Void) {
        NetworkManager.fetchDailyForecast(lat: list.coord.lat, lon: list.coord.lon) { [weak self] (forecast) in
            guard let self = self, let forecast = forecast else {return}
            self.cityForecast = forecast
            completion(true)
        }
    }
    
    var dayViewModels: [DayViewModel] {
        guard let daily = cityForecast?.daily else {return []}
        return daily.map {DayViewModel(daily: $0)}
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
