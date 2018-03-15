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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    var stationMO: [StationMO]?
    var favoriteStationDataList = [Int32: FavoriteStationData]()
    
    struct FavoriteStationData {
        var airQualityColor: UIColor?
        var pm10data: Double?
        var pm10indexLevelName: String?
        var pm25data: Double?
        var pm25indexLevelName: String?
    }
    
    var stationQuality = [AirQualityModel]()
    let decoder = DecoderUtils()
    let colorPicker = AirQualityColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
        
        //        tableView.tableFooterView = UIView(frame: .zero)
        //        tableView.backgroundColor = #colorLiteral(red: 0.9763854146, green: 0.9765252471, blue: 0.9763546586, alpha: 1)
        //        self.setStatusBarBackgroundColor(color: UIColor.black)
        //
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let request: NSFetchRequest<StationMO> = NSFetchRequest(entityName: "Station")
            let context = appDelegate.persistentContainer.viewContext
            do {
                stationMO = try context.fetch(request)
            } catch {
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        if let favoriteStations = stationMO {
            for station in favoriteStations {
                self.decoder.getStationAirQualityData(stationId: Int(station.id), completion: { [unowned self]
                    data in
                    if let data = data {
                        let color = self.colorPicker.calculateColorFor(parameter: AirParameters.airQuality ,with: data)
                        let pm10IndexLevelName = data.pm10IndexLevelName
                        let pm25IndexLevelName = data.pm25IndexLevelName
                        
                        self.favoriteStationDataList[station.id] = FavoriteStationData()
                        self.favoriteStationDataList[station.id]?.airQualityColor = color
                        self.favoriteStationDataList[station.id]?.pm10indexLevelName = pm10IndexLevelName
                        self.favoriteStationDataList[station.id]?.pm25indexLevelName = pm25IndexLevelName
                        
                        //                        if favoriteStations[0] == station {
                        ////                            self.setStatusBarBackgroundColor(color: color)
                        ////                            self.tableView.backgroundColor = color
                        //                            //                            self.tabBarController?.tabBar.barTintColor = color
                        //                        }
                    }
                    self.tableView.reloadData()
                })
                
                decoder.getSensorsListForStation(stationId: Int(station.id), completion: { [unowned self]
                    sensor in
                    
                    if let pm10sensor = sensor?
                        .filter({ $0.paramCode == "PM10" }) {
                        if pm10sensor.count != 0 {
                            self.decoder.getDataForSensor(sensorId: (pm10sensor.first?.sensorId)!, completion: {
                                sensorData in
                                for pm10 in (sensorData?.sensorValues)! {
                                    if pm10.value != nil {
                                        self.favoriteStationDataList[station.id]?.pm10data = pm10.value
                                        break
                                    }
                                }
                                self.tableView.reloadData()
                            })
                        }
                    }
                    
                    if let pm25sensor = sensor?
                        .filter({ $0.paramCode == "PM2.5" }) {
                        if pm25sensor.count != 0 {
                            self.decoder.getDataForSensor(sensorId: (pm25sensor.first?.sensorId)!, completion: {
                                sensorData in
                                for pm25 in (sensorData?.sensorValues)! {
                                    if pm25.value != nil {
                                        self.favoriteStationDataList[station.id]?.pm25data = pm25.value
                                        break
                                    }
                                }
                                self.tableView.reloadData()
                            })
                        }
                    }
                })
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        setStatusBarBackgroundColor(color: UIColor.clear)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if section == 0 {
            if let favoriteStations = stationMO {
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
            cell.cityNameLabel.text = stationMO?[indexPath.row].name
            
            if let id = stationMO?[indexPath.row].id {
                let station = favoriteStationDataList[id]
                
                cell.backgroundColor = station?.airQualityColor
                
                switch station?.airQualityColor {
                case #colorLiteral(red: 0.3059, green: 0.8588, blue: 0.0078, alpha: 1)?:
                    cell.setCellContentColor(color: UIColor.yellow)
                    break
                case #colorLiteral(red: 0.8078, green: 0.9882, blue: 0.0078, alpha: 1)?:
                    cell.setCellContentColor(color: UIColor.darkText)
                    break
                case #colorLiteral(red: 0.9882, green: 0.8745, blue: 0.0078, alpha: 1)?:
                    cell.setCellContentColor(color: UIColor.red)
                case #colorLiteral(red: 0.9765, green: 0.6235, blue: 0.0078, alpha: 1)?:
                    cell.setCellContentColor(color: UIColor.white)
                case #colorLiteral(red: 1, green: 0.0078, blue: 0.0078, alpha: 1)?:
                    cell.setCellContentColor(color: UIColor.white)
                case #colorLiteral(red: 0.6275, green: 0.0039, blue: 0.0039, alpha: 1)?:
                    cell.setCellContentColor(color: UIColor.white)
                default:
                    cell.setCellContentColor(color: UIColor.black)
                }
                
                cell.pm25quality.text = station?.pm25indexLevelName
                if let pm25level = station?.pm25data {
                    cell.pm25level.text = "\(String(Int((pm25level))))"
                }
                
                cell.pm10quality.text = station?.pm10indexLevelName
                if let pm10level = station?.pm10data {
                    cell.pm10level.text = "\(String(Int((pm10level))))"
                }
                
            }
            
            cell.pm25label.makeLabelRoundedBorder()
            cell.pm10label.makeLabelRoundedBorder()
            
//            let gradientBounds = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height-1)
//            let gradientLayer = gradient(frame: gradientBounds)
//            gradientLayer.name = "favoriteStation"
//
//            if let sublayers = cell.layer.sublayers {
//                for layer in sublayers {
//                    if layer.name == "favoriteStation" {
//                        layer.removeFromSuperlayer()
//                    }
//                }
//            }
//            cell.layer.insertSublayer(gradientLayer, at:0)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addStation", for: indexPath)
            cell.backgroundColor = tableView.backgroundColor
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let gradientBounds = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height-1)
        let gradientLayer = gradient(frame: gradientBounds)
        gradientLayer.name = "favoriteStation"
        
        if let sublayers = cell.layer.sublayers {
            for layer in sublayers {
                if layer.name == "favoriteStation" {
                    layer.removeFromSuperlayer()
                }
            }
        }
        cell.layer.insertSublayer(gradientLayer, at:0)

    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let context = appDelegate.persistentContainer.viewContext
                context.delete((stationMO?[indexPath.row])!)
                stationMO?.remove(at: indexPath.row)
                appDelegate.saveContext()
                
            }
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddFavoriteLocation" {
            
        }
    }
    
}

extension UIViewController {
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
}

extension UIViewController {
    func gradient(frame:CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        let transpatentColor = UIColor.white.withAlphaComponent(0.1)
        let btranspatentColor = UIColor.gray.withAlphaComponent(0.1)
        layer.colors = [
            btranspatentColor.cgColor, transpatentColor.cgColor ]
        return layer
    }
}

@IBDesignable class PaddingLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 10.0
    @IBInspectable var bottomInset: CGFloat = 10.0
    @IBInspectable var leftInset: CGFloat = 14.0
    @IBInspectable var rightInset: CGFloat = 14.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
    func makeLabelRoundedBorder() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = self.textColor.cgColor
        self.clipsToBounds = true
    }
    
}

