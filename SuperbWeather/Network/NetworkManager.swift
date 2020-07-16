//
//  NetworkManager.swift
//  SuperbWeather
//
//  Created by Joao Paulo Aquino on 16/07/20.
//  Copyright © 2020 Joao Paulo Aquino. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let apiKey = "27ab9c9807eb378ef4554be36762a2fa"
    
    static func fetchTemperatures(completion: @escaping (CitiesResponse?) -> Void) {
  
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/group"

        components.queryItems = [
            URLQueryItem(name: "id", value: "6167865,3448439,2618425,2643743"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: NetworkManager.apiKey)
        ]
        
        guard let url = components.url else {
            print("Failed to construct URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response
                , error) in
                guard let data = data else { return }
                do {

                    let decoder = JSONDecoder()
                    let citiesResponse = try decoder.decode(CitiesResponse.self, from: data)
                    completion(citiesResponse)

                } catch let err {
                    print("Err", err)
                    completion(nil)
                }
                }.resume()
    }
    
    static func fetchDailyForecast(lat: Double, lon: Double, completion: @escaping (CityForecast?) -> Void) {
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/onecall"

        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "exclude", value: "minutely,hourly"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: NetworkManager.apiKey)
        ]
        
        guard let url = components.url else {
            print("Failed to construct URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response
                , error) in
                guard let data = data else { return }
                do {

                    let decoder = JSONDecoder()
                    let cityForecast = try decoder.decode(CityForecast.self, from: data)
                    completion(cityForecast)

                } catch let err {
                    print("Err", err)
                    completion(nil)
                }
                }.resume()
    }
    
}
