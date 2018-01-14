//
//  SO2ViewCell.swift
//  AirQ
//
//  Created by aeronaut on 13.01.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import UIKit

class SO2ViewCell: UITableViewCell {

    @IBOutlet weak var so2Label: UILabel!
    
    @IBOutlet weak var so2DataLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
