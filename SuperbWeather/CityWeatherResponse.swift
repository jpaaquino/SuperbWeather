//
//  CityWeatherResponse.swift
//  SuperbWeather
//
//  Created by Joao Paulo Aquino on 15/07/20.
//  Copyright © 2020 Joao Paulo Aquino. All rights reserved.
//

import Foundation

// MARK: - CityWeatherResponse
struct CityWeatherResponse: Codable {
    let cod: String?
    let message: Double?
    let cnt: Int?
    let list: [CityWeatherList]?
    let city: CityWeatherCity?
}

// MARK: - City
struct CityWeatherCity: Codable {
    let id: Int?
    let name: String?
    let coord: CityWeatherCoord?
    let country: String?
}

// MARK: - Coord
struct CityWeatherCoord: Codable {
    let lat, lon: Double?
}

// MARK: - List
struct CityWeatherList: Codable {
    let dt: Int?
    let main: CityWeatherMainClass?
    let weather: [CityWeatherWeather]?
    let clouds: CityWeatherClouds?
    let wind: CityWeatherWind?
    let snow: CityWeatherSnow?
    let sys: CityWeatherSys?
    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, snow, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct CityWeatherClouds: Codable {
    let all: Int?
}

// MARK: - MainClass
struct CityWeatherMainClass: Codable {
    let temp, tempMin, tempMax, pressure: Double?
    let seaLevel, grndLevel: Double?
    let humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Snow
struct CityWeatherSnow: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct CityWeatherSys: Codable {
    let pod: CityWeatherPod?
}

enum CityWeatherPod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct CityWeatherWeather: Codable {
    let id: Int?
    let main: String?
    let weatherDescription: String?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct CityWeatherWind: Codable {
    let speed, deg: Double?
}
