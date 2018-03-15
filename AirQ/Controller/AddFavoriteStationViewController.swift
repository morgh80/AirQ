//
//  AddFavoriteStationViewController.swift
//  AirQ
//
//  Created by aeronaut on 11.02.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import UIKit

class AddFavoriteStationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var stationsList = [StationModel]()
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredStations = [StationModel]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationsList.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Station", for: indexPath) as! StationsListViewCell
        let station: StationModel
        if isFiltering() {
            station = filteredStations[indexPath.row]
        } else {
            station = stationsList[indexPath.row]
        }
        cell.stationNameLabel.text = station.cityName
        cell.adressLabel.text = station.stationName
        
        return cell
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddFavoriteStationViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredStations = stationsList.filter({( station : StationModel) -> Bool in
            return (station.cityName?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}
