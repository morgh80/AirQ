//
//  SensorDecoder.swift
//  AirQ
//
//  Created by aeronaut on 08.01.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import Foundation

struct SensorsListModel: Codable {
    
    var sensorId : Int?
    var stationId : Int?
    var sensorDateStart : String?
    var sensorDateEnd : String?
    
    var paramName : String?
    var paramFormula : String?
    var paramCode : String?
    var paramId : Int?
    
    enum SensorCodingKeys: String, CodingKey {
        case id
        case stationId
        case param
        case sensorDateStart
        case sensorDateEnd
    }
    
    enum ParamCodingKeys: String, CodingKey {
            case paramName
            case paramFormula
            case paramCode
            case idParam
        }
    
    init(from decoder: Decoder) throws {
        do {
        let values = try decoder.container(keyedBy: SensorCodingKeys.self)
        sensorId = try values.decodeIfPresent(Int.self, forKey: .id)
        stationId = try values.decodeIfPresent(Int.self, forKey: .stationId)
        sensorDateStart = try values.decodeIfPresent(String.self, forKey: .sensorDateStart)
        sensorDateEnd = try values.decodeIfPresent(String.self, forKey: .sensorDateEnd)
        
        let paramValues = try values.nestedContainer(keyedBy: ParamCodingKeys.self, forKey: .param)
        paramName = try paramValues.decodeIfPresent(String.self, forKey: .paramName)
        paramFormula = try paramValues.decodeIfPresent(String.self, forKey: .paramFormula)
        paramCode = try paramValues.decodeIfPresent(String.self, forKey: .paramCode)
        paramId = try paramValues.decodeIfPresent(Int.self, forKey: .idParam)
        } catch {
            print("Error decoding sensor values for station: \(String(describing: stationId))" )
        }
            
    }
    
}
