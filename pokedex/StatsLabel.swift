//
//  StatsLabel.swift
//  pokedex
//
//  Created by Joris Ooms on 15/04/16.
//  Copyright © 2016 Cup of Code. All rights reserved.
//

import UIKit

class StatsLabel: UILabel {
    override func awakeFromNib() {
        self.font = UIFont(name: "HelveticaNeue", size: 12.0)
        self.textColor = UIColor(hex: 0x333333)
    }
}
