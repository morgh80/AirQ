//
//  AirQualityViewControllerTableViewController.swift
//  AirQ
//
//  Created by aeronaut on 13.01.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import UIKit
import MapKit

class AirQualityViewController: UITableViewController {
    
    let decoder = DecoderUtils()
    
    var station: StationModel!
    var airQualityData: AirQualityModel?
    var airQualityDataColor: UIColor?
    var stationId: Int?
    var sensorsList: [SensorsListModel]?
    
    var pm10Data: Double?
    var pm25Data: Double?
    var no2Data: Double?
    var so2Data: Double?
        
    var colorPicker = ColorPicker()
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = station.cityName
        
        decoder.getStationAirQualityData(stationId: stationId!, completion: {
            data in
            if let data = data {
            self.airQualityData = data
            self.airQualityDataColor = self.colorPicker.calculateColorFor(airQuality: data)
            self.tableView.reloadData()
            }
        })
        
        decoder.getSensorsListForStation(stationId: stationId!, completion: {
            sensor in
            self.sensorsList = sensor
            
            if let pm10sensor = self.sensorsList?
                .filter({ $0.paramCode == "PM10" }) {
                if pm10sensor.count != 0 {
                    self.decoder.getDataForSensor(sensorId: (pm10sensor.first?.sensorId)!, completion: {
                        sensorData in
                        for value in (sensorData?.sensorValues)! {
                            if value.value != nil {
                                self.pm10Data = value.value
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
                    self.decoder.getDataForSensor(sensorId: (pm25sensor.first?.sensorId)!, completion: {
                        sensorData in
                        for value in (sensorData?.sensorValues)! {
                            if value.value != nil {
                                self.pm25Data = value.value
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
                    self.decoder.getDataForSensor(sensorId: (no2sensor.first?.sensorId)!, completion: {
                        sensorData in
                        for value in (sensorData?.sensorValues)! {
                            if value.value != nil {
                                self.no2Data = value.value
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
                    self.decoder.getDataForSensor(sensorId: (so2sensor.first?.sensorId)!, completion: {
                        sensorData in
                        for value in (sensorData?.sensorValues)! {
                            if value.value != nil {
                                self.so2Data = value.value
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
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "stIndexLevel", for: indexPath) as! AirQualityCell
            cell.airQualityLabel.text = airQualityData?.stIndexLevelName
            cell.backgroundColor = airQualityDataColor
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "pm10IndexLevel", for: indexPath) as! PM10ViewCell
            cell.pm10DataLabel.isHidden = true
            if airQualityData?.pm10IndexLevelName != nil {
                cell.pm10Label.text = airQualityData?.pm10IndexLevelName
            } else {
                cell.pm10Label.text = "-"
            }
            if pm10Data != nil {
                cell.pm10DataLabel.isHidden = false
                cell.pm10DataLabel.text = String(Int((pm10Data)!))
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "pm25IndexLevel", for: indexPath) as! PM25ViewCell
            cell.pm25DataLabel.isHidden = true
            if airQualityData?.pm25IndexLevelName != nil {
                cell.pm25Label.text = airQualityData?.pm25IndexLevelName
            } else {
                cell.pm25Label.text = "-"
            }
            if pm25Data != nil {
                cell.pm25DataLabel.isHidden = false
                cell.pm25DataLabel.text = String(Int((pm25Data)!))
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "no2IndexLevel", for: indexPath) as! NO2ViewCell
            cell.no2DataLabel.isHidden = true
            if airQualityData?.no2IndexLevelName != nil {
                cell.no2Label.text = airQualityData?.no2IndexLevelName
            } else {
                cell.no2Label.text = "-"
            }
            if no2Data != nil {
                cell.no2DataLabel.isHidden = false
                cell.no2DataLabel.text = String(Int((no2Data)!))
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "so2IndexLevel", for: indexPath) as! SO2ViewCell
            cell.so2DataLabel.isHidden = true
            if airQualityData?.so2IndexLevelName != nil {
                cell.so2Label.text = airQualityData?.so2IndexLevelName

            } else {
                cell.so2Label.text = "-"
            }
            if so2Data != nil {
                cell.so2DataLabel.isHidden = false
                cell.so2DataLabel.text = String(Int((so2Data)!))
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "separator", for: indexPath) as! SeparatorCell
            return cell
        case 6:
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
        
        if indexPath.row == 6 {
            return 300.0
        }
        return 35.0
    }

    
}
