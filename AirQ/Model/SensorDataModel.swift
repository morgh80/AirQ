//
//  ParamDecoder.swift
//  AirQ
//
//  Created by aeronaut on 08.01.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import Foundation

struct SensorDataModel: Codable {
    
    var key : String?
    var sensorValues : [Values]?
    
    enum ParamCodingKeys: String, CodingKey {
        case key
        case values
    }
    
    enum ValuesCodingKeys: String, CodingKey {
        case date
        case value
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: ParamCodingKeys.self)
            key = try container.decodeIfPresent(String.self, forKey: .key)
            sensorValues = try container.decodeIfPresent([Values].self, forKey: .values)
        } catch {
            print("Error decoding sensor for: \(String(describing: key)) \(error.localizedDescription)")
        }
    }
    
}

struct Values : Codable {
    
    var date : String?
    var value : Double?
    
    enum ValuesCodingKeys: String, CodingKey {
        case date
        case value
    }
    
    init(from decoder: Decoder) {
        do{
            let container = try decoder.container(keyedBy: ValuesCodingKeys.self)
            date = try container.decodeIfPresent(String.self, forKey: .date)
            value = try container.decodeIfPresent(Double.self, forKey: .value)
        } catch {
            print("Error decoding sensor values \(error.localizedDescription)")
        }
    }
    
}




