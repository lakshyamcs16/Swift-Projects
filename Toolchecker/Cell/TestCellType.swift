//
//  TestCellType.swift
//  Toolchecker
//
//  Created by Aashna Narula on 23/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit

class TestCellType: UICollectionViewCell {
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testImage: UIImageView!
    
    override func awakeFromNib() {

    }
    
    func setupCell(name: String) {
        self.testLabel.text = name
    }
}
