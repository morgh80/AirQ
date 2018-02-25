//
//  AirQualityViewControllerTableViewController.swift
//  AirQ
//
//  Created by aeronaut on 13.01.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AirQualityViewController: UITableViewController {
    
    let decoder = DecoderUtils()
    let colorPicker = AirQualityColor()
    
    var station: StationModel!
    var stationId: Int?
    var sensorsList: [SensorsListModel]?
    
    var airQualityData: AirQualityModel?
    var airQualityColor: UIColor?
    
    var pm10data: Double?
    var pm10color: UIColor?
    
    var pm25data: Double?
    var pm25color: UIColor?
    
    var no2data: Double?
    var no2color: UIColor?
    
    var so2data: Double?
    var so2color: UIColor?
    
    var location: CLLocation?
    
    @IBAction func addToFavorites(_ sender: Any) {
        if let appDelegate = (UIApplication.shared.delegate) as? AppDelegate {
        let favoriteStation = StationMO(context: appDelegate.persistentContainer.viewContext)
            favoriteStation.id = Int32(stationId!)
            favoriteStation.name = station.cityName
            appDelegate.saveContext()
           performSegue(withIdentifier: "goBackToFavorites", sender: nil)
            dismiss(animated: true, completion: nil)

        }
    }

    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "showAddFavoriteLocation" {
     //            let navController = segue.destination as! UINavigationController
     let destinationController = segue.destination as! StationsListViewController
     //            destinationController.stationsList
     }
     }
 */
    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "goBackToFavorites" {
//            let destination = segue.destination as! FavoriteStationsViewController
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableView.separatorColor = UIColor.white
        tableView.separatorInset = UIEdgeInsetsMake(0,0,0,0)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = station.cityName
        
        self.navigationController?.navigationBar.isHidden = false

        
        decoder.getStationAirQualityData(stationId: stationId!, completion: { [unowned self]
            data in
            if let data = data {
                self.airQualityData = data
                self.airQualityColor = self.colorPicker.calculateColorFor(parameter: AirParameters.airQuality ,with: data)
                self.pm10color = self.colorPicker.calculateColorFor(parameter: AirParameters.pm10, with: data)
                self.pm25color = self.colorPicker.calculateColorFor(parameter: AirParameters.pm25, with: data)
                self.no2color = self.colorPicker.calculateColorFor(parameter: AirParameters.no2, with: data)
                self.so2color = self.colorPicker.calculateColorFor(parameter: AirParameters.so2, with: data)
                self.tableView.reloadData()
            }
        })
        
        decoder.getSensorsListForStation(stationId: stationId!, completion: { [unowned self]
            sensor in
            self.sensorsList = sensor
            
            if let pm10sensor = self.sensorsList?
                .filter({ $0.paramCode == "PM10" }) {
                if pm10sensor.count != 0 {
                    self.decoder.getDataForSensor(sensorId: (pm10sensor.first?.sensorId)!, completion: {
                        sensorData in
                        for value in (sensorData?.sensorValues)! {
                            if value.value != nil {
                                self.pm10data = value.value
                                break
                            }
                        }
                        self.tableView.reloadData()
                    })
                }
            }
            
            if let pm25sensor = self.sensorsList?
                .filter({ $0.paramCode == "PM2.5" }) {
                if pm25sensor.count != 0 {
                    self.decoder.getDataForSensor(sensorId: (pm25sensor.first?.sensorId)!, completion: { [unowned self]
                        sensorData in
                        for value in (sensorData?.sensorValues)! {
                            if value.value != nil {
                                self.pm25data = value.value
                                break
                            }
                        }
                        self.tableView.reloadData()
                    })
                }
            }
            
            if let no2sensor = self.sensorsList?
                .filter({ $0.paramCode == "NO2" }) {
                if no2sensor.count != 0 {
                    self.decoder.getDataForSensor(sensorId: (no2sensor.first?.sensorId)!, completion: { [unowned self]
                        sensorData in
                        for value in (sensorData?.sensorValues)! {
                            if value.value != nil {
                                self.no2data = value.value
                                break
                            }
                        }
                        self.tableView.reloadData()
                    })
                }
            }
            
            if let so2sensor = self.sensorsList?
                .filter({ $0.paramCode == "SO2" }) {
                if so2sensor.count != 0 {
                    self.decoder.getDataForSensor(sensorId: (so2sensor.first?.sensorId)!, completion: { [unowned self]
                        sensorData in
                        for value in (sensorData?.sensorValues)! {
                            if value.value != nil {
                                self.so2data = value.value
                                break
                            }
                        }
                        self.tableView.reloadData()
                    })
                }
            }
            
            self.tableView.reloadData()
        })
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "stIndexLevel", for: indexPath) as! AirQualityCell
            cell.airQualityLabel.text = airQualityData?.stIndexLevelName
            cell.backgroundColor = airQualityColor
            cell.addBorderBottom(size: 1, color: UIColor.white)
//            let background = UIView()
//            cell.layer.insertSublayer(background.makeGradient(frame: cell.bounds), at: 0)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "pm10IndexLevel", for: indexPath) as! PM10ViewCell
            if airQualityData?.pm10IndexLevelName != nil {
                cell.pm10DataLabel.text = airQualityData?.pm10IndexLevelName
            }
            if pm10data != nil {
                cell.pm10Label.text = "\(String(Int((pm10data)!))) (20)"
            }
            cell.backgroundColor = pm10color
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "pm25IndexLevel", for: indexPath) as! PM25ViewCell
            if airQualityData?.pm25IndexLevelName != nil {
                cell.pm25DataLabel.text = airQualityData?.pm25IndexLevelName
            }
            if pm25data != nil {
                cell.pm25Label.text = "\(String(Int((pm25data)!))) (12)"
            }
            cell.backgroundColor = pm25color
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "no2IndexLevel", for: indexPath) as! NO2ViewCell
            if airQualityData?.no2IndexLevelName != nil {
                cell.no2DataLabel.text = airQualityData?.no2IndexLevelName
            }
            if no2data != nil {
                cell.no2Label.text = "\(String(Int((no2data)!))) (40)"
            }
            cell.backgroundColor = no2color
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "so2IndexLevel", for: indexPath) as! SO2ViewCell
            if airQualityData?.so2IndexLevelName != nil {
                cell.so2DataLabel.text = airQualityData?.so2IndexLevelName
            }
            if so2data != nil {
                cell.so2Label.text = "\(String(Int((so2data)!))) (50)"
            }
            cell.backgroundColor = so2color
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "showMap", for: indexPath) as! MapCell
            if let latitude = station.gegrLat {
                if let longtitude = station.gegrLon {
                    location = CLLocation(latitude: Double(latitude)!, longitude: Double(longtitude)!)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longtitude)!)
                    
                    let regionRadius: CLLocationDistance = 100000
                    let coordinateRegion = MKCoordinateRegionMakeWithDistance((location?.coordinate)!,regionRadius, regionRadius)
                    cell.mapView.setRegion(coordinateRegion, animated: true)
                    
                    cell.mapView.addAnnotation(annotation)
                }
            }
            return cell
        default:
            fatalError("Failed to initiate cell")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70.0
        }
        
        if indexPath.row == 1 {
            if self.pm10data == nil {
                return 0
            }
        }
        if indexPath.row == 2 {
            if self.pm25data == nil {
                return 0
            }
        }
        if indexPath.row == 1 {
            if self.pm10data == nil {
                return 0
            }
        }
        if indexPath.row == 3 {
            if self.no2data == nil {
                return 0
            }
        }
        if indexPath.row == 4 {
            if self.so2data == nil {
                return 0
            }
        }
        if indexPath.row == 5 {
            return 300.0
        }
        return 50.0
    }
    
}

extension UIView {
    func addBorderTop(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }
    func addBorderBottom(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }
    func addBorderLeft(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
    }
    func addBorderRight(size: CGFloat, color: UIColor) {
        addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }
    private func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
}

extension UIView {
    func makeGradient(frame:CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1.0)
        layer.colors = [
            UIColor.clear.cgColor, UIColor.white.cgColor]
        layer.opacity = 0.1
        return layer
}
}
