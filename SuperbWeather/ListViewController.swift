//
//  ViewController.swift
//  SuperbWeather
//
//  Created by Joao Paulo Aquino on 14/07/20.
//  Copyright © 2020 Joao Paulo Aquino. All rights reserved.
//

import UIKit
import Kingfisher

class ListViewController: UIViewController {
    
    var listViewModels: [CityCellViewModel] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
        configureView()
    }
    
    func configureView() {
        //tableView.tableFooterView = UIView()
        self.title = "Superb Weather"
    }
    
    func fetchAll() {
        NetworkManager.fetchTemperatures() {[weak self] (response) in
            guard let response = response else {return}
            self?.listViewModels = response.list.map {CityCellViewModel(list: $0)}
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CityCell else {return UITableViewCell()}
        let viewModel = listViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CityViewController") as! CityViewController
        let list = listViewModels[indexPath.row].list
        vc.cityViewModel = CityViewModel(list: list)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

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

class CityCellViewModel {
    
    init(list: List) {
        self.list = list
    }
    
    let list: List
    
    var temperature: String {
        let temp = Int(list.main.temp)
        return "\(temp)°"
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
    
    static func fetchForecast(for cityId: Int, completion: @escaping (CityWeatherResponse?) -> Void) {
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/forecast"

        components.queryItems = [
            URLQueryItem(name: "id", value: String(cityId)),
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
                    let cityResponse = try decoder.decode(CityWeatherResponse.self, from: data)
                    completion(cityResponse)

                } catch let err {
                    print("Err", err)
                    completion(nil)
                }
                }.resume()
        
    }
    
}
