//
//  FavoriteStation.swift
//  AirQ
//
//  Created by aeronaut on 24.02.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import UIKit

class FavoriteStationCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var pm25label: PaddingLabel!
    @IBOutlet weak var pm10label: PaddingLabel!
    
    @IBOutlet weak var pm25level: PaddingLabel!
    @IBOutlet weak var pm25quality: UILabel!
    
    @IBOutlet weak var pm10level: PaddingLabel!
    @IBOutlet weak var pm10quality: UILabel!
    
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var verticalLine: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension FavoriteStationCell {
    func setCellContentColor(color: UIColor) {
        self.cityNameLabel.textColor = color
        self.pm25label.textColor = color
        self.pm25level.textColor = color
        self.pm25quality.textColor = color
        self.pm10label.textColor = color
        self.pm10level.textColor = color
        self.pm10quality.textColor = color
        self.topLine.backgroundColor = color
        self.verticalLine.backgroundColor = color
        self.bottomLine.backgroundColor = color
    }
    
//    func previousStationhasSameAirQuality() -> Bool {
//
//
//    }
    
}
