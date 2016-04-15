//
//  StatsTitleLabel.swift
//  pokedex
//
//  Created by Joris Ooms on 15/04/16.
//  Copyright © 2016 Cup of Code. All rights reserved.
//

import UIKit

class StatsTitleLabel: UILabel {
    override func awakeFromNib() {
        self.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
        self.textColor = UIColor(hex: 0xFF5855)
    }
}
