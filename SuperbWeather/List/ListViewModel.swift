//
//  ListViewModel.swift
//  SuperbWeather
//
//  Created by Joao Paulo Aquino on 16/07/20.
//  Copyright © 2020 Joao Paulo Aquino. All rights reserved.
//

import Foundation

class ListViewModel {
    
    var cityViewModels: [CityCellViewModel] = []
    
    var title: String = "Superb Weather"
    
    func fetchList(completion: @escaping (Bool) -> Void) {
        NetworkManager.fetchTemperatures() {[weak self] (response) in
            guard let self = self, let response = response else {return}
            self.cityViewModels = response.list.map {CityCellViewModel(list: $0)}
            completion(true)
        }
    }

}
