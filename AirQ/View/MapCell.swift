//
//  MapCell.swift
//  AirQ
//
//  Created by aeronaut on 14.01.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import UIKit
import MapKit

class MapCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
