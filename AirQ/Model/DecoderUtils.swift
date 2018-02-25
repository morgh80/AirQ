//
//  Decoder.swift
//  AirQ
//
//  Created by aeronaut on 09.01.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import Foundation

class DecoderUtils {
    
    public func getStationsList(completion: @escaping ([StationModel]?) -> Void) {
        let allStationsUrl = URL(string: "http://api.gios.gov.pl/pjp-api/rest/station/findAll")
        let task = URLSession.shared.dataTask(with: allStationsUrl!)  { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                DispatchQueue.main.async {
                    if let stationModel = try? jsonDecoder.decode([StationModel].self, from: data) {
                        completion(stationModel)
                    } else {
                        print("StationModel: Either no data was returned, or data was not properly decoded.")
                        completion(nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
    
    public func getStationAirQualityData(stationId: Int, completion: @escaping (AirQualityModel?) -> Void) {
        let allStationsUrl = URL(string: "http://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/\(stationId)")
        let task = URLSession.shared.dataTask(with: allStationsUrl!)  { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                DispatchQueue.main.async {
                    if let airQualityModel = try? jsonDecoder.decode(AirQualityModel.self, from: data) {
                        completion(airQualityModel)
                    } else {
                        print("AirQualityModel: Either no data was returned, or data was not properly decoded.")
                        completion(nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    public func getSensorsListForStation(stationId: Int, completion: @escaping ([SensorsListModel]?) -> Void) {
        let allStationsUrl = URL(string: "http://api.gios.gov.pl/pjp-api/rest/station/sensors/\(stationId)")
        let task = URLSession.shared.dataTask(with: allStationsUrl!)  { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                DispatchQueue.main.async {
                    if let sensorModel = try? jsonDecoder.decode([SensorsListModel].self, from: data) {
                        completion(sensorModel)
                    } else {
                        print("SensorListModel: Either no data was returned, or data was not properly decoded.")
                        completion(nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    public func getDataForSensor(sensorId: Int, completion: @escaping (SensorDataModel?) -> Void) {
        let allStationsUrl = URL(string: "http://api.gios.gov.pl/pjp-api/rest/data/getData/\(sensorId)")
        let task = URLSession.shared.dataTask(with: allStationsUrl!)  { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                DispatchQueue.main.async {
                    if let sensorDataModel = try? jsonDecoder.decode(SensorDataModel.self, from: data) {
                        completion(sensorDataModel)
                    } else {
                        print("SensorDataModel: Either no data was returned, or data was not properly decoded.")
                        completion(nil)
                    }
                }
            }
        }
        task.resume()
    }
    
}


