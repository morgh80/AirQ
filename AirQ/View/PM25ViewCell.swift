//
//  PM25ViewCell.swift
//  Pods-AirQ
//
//  Created by aeronaut on 13.01.2018.
//

import UIKit

class PM25ViewCell: UITableViewCell {

    @IBOutlet weak var pm25Label: UILabel!
    
    @IBOutlet weak var pm25DataLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
