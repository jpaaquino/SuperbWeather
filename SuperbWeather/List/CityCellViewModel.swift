//
//  CityCellViewModel.swift
//  SuperbWeather
//
//  Created by Joao Paulo Aquino on 16/07/20.
//  Copyright © 2020 Joao Paulo Aquino. All rights reserved.
//

import Foundation

class CityCellViewModel {
    
    init(list: List) {
        self.list = list
    }
    
    let list: List
    
    var temperature: String {
        let temp = Int(list.main.temp)
        return "\(temp)°"
    }
    
    var lat: Double {
        return list.coord.lat
    }
    
    var lon: Double {
        return list.coord.lon
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
