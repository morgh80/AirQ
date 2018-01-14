//
//  ViewController.swift
//  AirQ
//
//  Created by aeronaut on 07.01.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import UIKit

class StationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let decoder = DecoderUtils()
    var stationsList = [StationModel]()

    let searchController = UISearchController(searchResultsController: nil)

    var filteredStations = [StationModel]()


    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {

        super.viewDidLoad()

        decoder.getStationsListWithDecoder(completion: {
            stations in
            self.stationsList = stations!

            self.stationsList = self.stationsList
                .filter { $0.cityName != nil }
                .sorted { $0.cityName! < $1.cityName! }

            self.tableView.reloadData()
        })

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredStations.count
        }

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStationDetails" {
            let destinationController = segue.destination as! AirQualityViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                destinationController.station = self.stationsList[indexPath.row]
                destinationController.stationId = self.stationsList[indexPath.row].stationId
            }
        }
    }

}

extension StationsListViewController: UISearchResultsUpdating {

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


