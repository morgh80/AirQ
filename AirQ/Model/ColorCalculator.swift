//
//  ColorPicker.swift
//  AirQ
//
//  Created by aeronaut on 18.01.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import Foundation
import UIKit

class ColorCalculator {
    
    let veryGood = #colorLiteral(red: 0.3059, green: 0.8588, blue: 0.0078, alpha: 1)
    let good = #colorLiteral(red: 0.8078, green: 0.9882, blue: 0.0078, alpha: 1)
    let moderate = #colorLiteral(red: 0.9882, green: 0.8745, blue: 0.0078, alpha: 1)
    let adequate = #colorLiteral(red: 0.9765, green: 0.6235, blue: 0.0078, alpha: 1)
    let bad = #colorLiteral(red: 1, green: 0.0078, blue: 0.0078, alpha: 1)
    let veryBad = #colorLiteral(red: 0.6275, green: 0.0039, blue: 0.0039, alpha: 1)
    let noData = #colorLiteral(red: 0.8588, green: 0.8588, blue: 0.8588, alpha: 1)
    
    func calculateColorFor(parameter: AirParameters, with model: AirQualityModel) -> UIColor {
        let quality: Int?
        switch parameter {
        case.airQuality:
            quality = model.stQualityId
        case .pm10:
            quality = model.pm10qualityId
        case .pm25:
            quality = model.pm25qualityId
        case .no2:
            quality = model.no2qualityId
        case.so2:
            quality = model.so2qualityId
        }
        switch quality {
        case 0?:
            return veryGood
        case 1?:
            return good
        case 2?:
            return moderate
        case 3?:
            return adequate
        case 4?:
            return bad
        case 5?:
            return veryBad
        default:
            return noData
        }
    }
    
}


protocol Colors { }
