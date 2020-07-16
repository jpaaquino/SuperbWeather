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
    
    @IBOutlet weak var tableView: UITableView!
    let listViewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchList()
    }
    
    func configureView() {
        self.title = listViewModel.title
    }
    
    func fetchList() {
        listViewModel.fetchList {[weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.cityViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CityCell else {return UITableViewCell()}
        let viewModel = listViewModel.cityViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CityViewController") as! CityViewController
        let list = listViewModel.cityViewModels[indexPath.row].list
        vc.cityViewModel = CityViewModel(list: list)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
