//
//  StationViewCell.swift
//  AirQ
//
//  Created by aeronaut on 12.01.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import UIKit

class StationsListViewCell: UITableViewCell {
    
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
