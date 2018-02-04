//
//  QualityDecoder.swift
//  AirQ
//
//  Created by aeronaut on 09.01.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import Foundation

struct AirQualityModel: Codable {
    
    var stationId : Int?
    var stCalcDate: String?
    var stQualityId : Int?
    var stIndexLevelName : String?
    var pm10SourceDataDate : String?
    var pm10qualityId : Int?
    var pm10IndexLevelName : String?
    var pm25SourceDataDate : String?
    var pm25qualityId : Int?
    var pm25IndexLevelName : String?
    var no2SourceDataDate : String?
    var no2qualityId : Int?
    var no2IndexLevelName : String?
    var so2SourceDataDate : String?
    var so2qualityId : Int?
    var so2IndexLevelName : String?
    
    
    enum QualityCodingKeys: String, CodingKey {
        case id
        case stCalcDate
        case stIndexLevel
        case stSourceDataDate
        case so2CalcDate
        case so2IndexLevel
        case so2SourceDataDate
        case no2CalcDate
        case no2IndexLevel
        case no2SourceDataDate
        case coCalcDate
        case coIndexLevel
        case coSourceDataDate
        case pm10CalcDate
        case pm10IndexLevel
        case pm10SourceDataDate
        case pm25CalcDate
        case pm25IndexLevel
        case pm25SourceDataDate
        case o3CalcDate
        case o3IndexLevel
        case o3SourceDataDate
        case c6h6CalcDate
        case c6h6IndexLevel
        case c6h6SourceDataDate
    }
    
    enum IndexCodingKeys: String, CodingKey {
        case id
        case indexLevelName
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: QualityCodingKeys.self)
            let stValues = try values.nestedContainer(keyedBy: IndexCodingKeys.self, forKey: .stIndexLevel)
            let pm10values = try? values.nestedContainer(keyedBy: IndexCodingKeys.self, forKey: .pm10IndexLevel)
            let pm25values = try? values.nestedContainer(keyedBy: IndexCodingKeys.self, forKey: .pm25IndexLevel)
            let no2values = try? values.nestedContainer(keyedBy: IndexCodingKeys.self, forKey: .no2IndexLevel)
            let so2values = try? values.nestedContainer(keyedBy: IndexCodingKeys.self, forKey: .so2IndexLevel)

            
            stationId = try values.decodeIfPresent(Int.self, forKey: .id)
            stCalcDate = try values.decodeIfPresent(String.self, forKey: .stCalcDate)
            stQualityId = try stValues.decodeIfPresent(Int.self, forKey: .id)
            stIndexLevelName = try stValues.decodeIfPresent(String.self, forKey: .indexLevelName)

            pm10SourceDataDate = try values.decodeIfPresent(String.self, forKey: .pm10SourceDataDate)
            pm10qualityId = try pm10values?.decodeIfPresent(Int.self, forKey: .id)
            pm10IndexLevelName = try pm10values?.decodeIfPresent(String.self, forKey: .indexLevelName)
            
            pm25SourceDataDate = try values.decodeIfPresent(String.self, forKey: .pm25SourceDataDate)
            pm25qualityId = try pm25values?.decodeIfPresent(Int.self, forKey: .id)
            pm25IndexLevelName = try pm25values?.decodeIfPresent(String.self, forKey: .indexLevelName)
            
            no2SourceDataDate = try values.decodeIfPresent(String.self, forKey: .no2SourceDataDate)
            no2qualityId = try no2values?.decodeIfPresent(Int.self, forKey: .id)
            no2IndexLevelName = try no2values?.decodeIfPresent(String.self, forKey: .indexLevelName)
            
            so2SourceDataDate = try values.decodeIfPresent(String.self, forKey: .so2SourceDataDate)
            so2qualityId = try so2values?.decodeIfPresent(Int.self, forKey: .id)
            so2IndexLevelName = try so2values?.decodeIfPresent(String.self, forKey: .indexLevelName)
            
        } catch {
            print("Error decoding air quality values for: \(String(describing: stationId))")
        }
    }
}

