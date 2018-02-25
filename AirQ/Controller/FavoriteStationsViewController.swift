//
//  FavoriteStationsViewController.swift
//  AirQ
//
//  Created by aeronaut on 01.02.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import UIKit
import CoreData

class FavoriteStationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var StationMO: [StationMO]?
    var airQualityColor = [Int32: UIColor]()
    var stationQuality = [AirQualityModel]()
    let decoder = DecoderUtils()
    let colorPicker = AirQualityColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        //        tableView.backgroundColor = UIColor.black
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            let request: NSFetchRequest<StationMO> = StationMO.fetchRequest
            let request: NSFetchRequest<StationMO> = NSFetchRequest(entityName: "Station")

            let context = appDelegate.persistentContainer.viewContext
            do {
                StationMO = try context.fetch(request)
            } catch {
                print(error)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        if let favoriteStations = StationMO {
            for station in favoriteStations {
                self.decoder.getStationAirQualityData(stationId: Int(station.id), completion: { [unowned self]
                    data in
                    if let data = data {
//                        self.stationQuality.append(data)
                        let color = self.colorPicker.calculateColorFor(parameter: AirParameters.airQuality ,with: data)
                        self.airQualityColor[station.id] = color
                        self.tableView.reloadData()
                    }
                })
            }
        }
    
    
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if section == 0 {
            if let favoriteStations = StationMO {
                rows = favoriteStations.count
            }
        }
        if section == 1 {
            rows = 1
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteStation", for: indexPath) as! FavoriteStationCell
            cell.cityNameLabel.text = StationMO?[indexPath.row].name
            if let id = StationMO?[indexPath.row].id {
            cell.backgroundColor = airQualityColor[id]                
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addStation", for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70.0
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let headerHeight: CGFloat
        
        switch section {
        case 0:
            // hide the header
            headerHeight = CGFloat.leastNonzeroMagnitude
        default:
            headerHeight = 21
        }
        
        return headerHeight
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddFavoriteLocation" {
            //            let navController = segue.destination as! UINavigationController
            let destinationController = segue.destination as! StationsListViewController
            //            destinationController.stationsList
        }
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
