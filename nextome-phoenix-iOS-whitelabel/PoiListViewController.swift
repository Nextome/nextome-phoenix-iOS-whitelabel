//
//  PoiListViewController.swift
//  nextome-phoenix-iOS-whitelabel
//
//  Created by Anna Labellarte on 29/03/23.
//

import UIKit
import PhoenixSdk

class PoiListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, PoiListDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let cellId = "poiCell"
    var poiList: [NextomePoi] = []
   

    var onPoiSelected: (NextomePoi)->() = {_ in }
    var viewModel = PoiListViewModel()
    var uiData: [String]{
        get{
            viewModel.uiData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.setPoi(poiList: poiList)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PoiTableViewCell
        let item = self.uiData[indexPath.row]
        cell.label.text = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.getItem(index: indexPath.row)
        onPoiSelected(item)
        self.dismiss(animated: true)

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.updateFilter(filterValue: searchBar.text)
    }
    
    func onListUpdated() {
        tableView.reloadData()
    }


}
