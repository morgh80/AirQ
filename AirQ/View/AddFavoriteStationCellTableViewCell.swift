//
//  AddFavoriteStationCellTableViewCell.swift
//  AirQ
//
//  Created by aeronaut on 10.03.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import UIKit

class AddFavoriteStationCellTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let gradientBounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height-1)
//        let gradientLayer = gradient(frame: gradientBounds)
//        gradientLayer.name = "favoriteStation"
//        
//        
//        self.addSubview(gradientLayer, at:0)

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func gradient(frame:CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        let transpatentColor = UIColor.white.withAlphaComponent(0.1)
        let btranspatentColor = UIColor.gray.withAlphaComponent(0.1)
        layer.colors = [
            btranspatentColor.cgColor, transpatentColor.cgColor ]
        return layer
    }
    
}
