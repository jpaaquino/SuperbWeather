//
//  ViewController.swift
//  SuperbWeather
//
//  Created by Joao Paulo Aquino on 14/07/20.
//  Copyright © 2020 Joao Paulo Aquino. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    var listViewModels: [CityViewModel] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
    }
    
    func fetchAll() {
        NetworkManager.fetchTemperatures() {[weak self] (response) in
            guard let response = response else {return}
            self?.listViewModels = response.list.map {CityViewModel(list: $0)}
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
        let viewModel = listViewModels[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CityViewController") as! CityViewController
        vc.viewModel = viewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class CityCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func configure(with viewModel: CityViewModel) {
        nameLabel.text = viewModel.name
        temperatureLabel.text = String(Int(viewModel.temperature)) + "°"
    }
    
}

class CityViewModel {
    
    init(list: List) {
        self.name = list.name
        self.temperature = list.main.temp
    }
    
    let temperature: Double
    let name: String
    
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
            preconditionFailure("Failed to construct URL")
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
    
}
