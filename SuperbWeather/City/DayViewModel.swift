//
//  DayViewModel.swift
//  SuperbWeather
//
//  Created by Joao Paulo Aquino on 16/07/20.
//  Copyright © 2020 Joao Paulo Aquino. All rights reserved.
//

import Foundation

class DayViewModel {
    
    init(daily: Daily) {
        self.daily = daily
    }
    
    let daily: Daily
    
    var date: String? {
        guard let dt = daily.dt else {return nil}
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        return date.dayOfTheWeek()
    }
    
    var iconURL: URL? {
        guard let iconId = daily.weather?.first?.icon else {return nil}
        return URL(string: "http://openweathermap.org/img/w/\(iconId).png")
    }
    
    var temperature: String {
        var minTemp = "-"
        if let min = daily.temp?.min {
            minTemp = "\(Int(min))°"
        }
        var maxTemp = "-"
        if let max = daily.temp?.max {
            maxTemp = "\(Int(max))°"
        }
        return minTemp + "|" + maxTemp
    }
}
