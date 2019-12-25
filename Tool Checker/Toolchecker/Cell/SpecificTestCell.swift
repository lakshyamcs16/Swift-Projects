//
//  SpecificTestCell.swift
//  Toolchecker
//
//  Created by Aashna Narula on 23/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit

class SpecificTestCell: UITableViewCell {

    @IBOutlet weak var testIcon: UIImageView!
    @IBOutlet weak var testName: UILabel!
    func setupCell(name: String, icon: UIImage) {
        self.testIcon.image = icon
        self.testName.text = name
    }
}
