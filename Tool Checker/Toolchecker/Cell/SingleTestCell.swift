//
//  SingleTestCell.swift
//  Toolchecker
//
//  Created by Aashna Narula on 25/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit

class SingleTestCell: UITableViewCell {

    @IBOutlet weak var testIcon: UIImageView!
    @IBOutlet weak var testName: UILabel!
    func setupCell(name: String, icon: String) {
        self.testIcon.image = UIImage(named: icon)
        self.testName.text = name
    }
}
