//
//  Setups.swift
//  Toolchecker
//
//  Created by Aashna Narula on 25/01/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//

import UIKit

class Setups {
    static func setupVCScreen(this: BatteryCheckVC, name: String, subtitle: String, image: String, button: String) {
        this.nameLabel.text = name
        this.subtitle.text = subtitle
        this.iconImage.image = UIImage(named: image)
        this.checkButton.setTitle(button, for: .normal)
    }
    
}
