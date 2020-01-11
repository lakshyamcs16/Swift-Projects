//
//  GyroscopeHeaderCell.swift
//  Toolchecker
//
//  Created by Aashna Narula on 09/01/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//

import UIKit

class GyroscopeHeaderCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    func setupCell(name: String) {
        self.labelName.text = name
    }
}

class GyroscopeDetailsCell: UITableViewCell {
    
    @IBOutlet weak var labelA: UILabel!
    @IBOutlet weak var labelB: UILabel!
    @IBOutlet weak var labelC: UILabel!
    
    func setupCell(a: String, b: String, c: String) {
        self.labelA.text = a
        self.labelB.text = b
        self.labelC.text = c
    }
}
