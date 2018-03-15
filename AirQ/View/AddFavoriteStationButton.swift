//
//  AddFavoriteStationCell.swift
//  AirQ
//
//  Created by aeronaut on 10.03.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import UIKit

class AddFavoriteStationButton: UIButton {
    
    func makeRoundButton(color: UIColor)  {
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
//        print("Height: \(self.bounds.size.height), width: \(self.bounds.size.width)")
    }
   
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        makeRoundButton(color: UIColor.white)
//    }

    
    
    
}
