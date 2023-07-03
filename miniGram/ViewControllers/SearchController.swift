//
//  SearchController.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 7/5/23.
//

import UIKit
import ActionKit

class SearchController: UIViewController {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    
    let data : [String] = [
        "Mango",
        "Apple",
        "Orange",
        "Kiwifruit",
        "Grape",
        "Cherry",
        "Avocado"
    ]
    
    var filteredFruits: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchField.delegate = self
        
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
        
        self.searchButton.addControlEvent(.touchUpInside) {
            guard let searchText = self.searchField.text, searchText.count > 0 else {
                MinigramApp.showAlert(from: self, title: "Search term too short", message: "Please enter your search term!")
                return
            }
            self.handleSearch(searchText: searchText)
        }
    }

    func handleSearch (searchText: String) {
        print("searching -> \(searchText)")
        self.filteredFruits = self.getFruitsBySearchTerm(keyword: searchText)
        self.searchTableView.reloadData()
    }
    
    func getFruitsBySearchTerm (keyword: String) -> [String] {
        self.data.filter { item in
            if item.lowercased().hasPrefix(keyword.lowercased()) {
                return true
            }
            return false
        }
    }
    
}

extension SearchController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension SearchController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = filteredFruits.count
        if count > 0 {
            self.searchTableView.backgroundView = nil
        } else {
            if let noDataView = Bundle.main.loadNibNamed("NoDataView", owner: self)?.first as? NoDataView {
                self.searchTableView.backgroundView = noDataView
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var mCell: UITableViewCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UITableViewCell {
            mCell = cell
        } else {
            mCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        let fruit = self.filteredFruits[indexPath.row]
        mCell.textLabel?.text = fruit
        return mCell
    }
    
}
