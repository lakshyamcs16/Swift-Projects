//
//  SingleTestListVM.swift
//  Toolchecker
//
//  Created by Aashna Narula on 25/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import Foundation

class SingleTestListVM {
    var array: [testNames] = []
    var imagesArray:[String] = []
    
    init() {
        self.array = [.simCard, .mobileCarrier, .wifi,.charging, .display,.rearCamera,.frontCamera,.vibration,.touchScreen,.earpiece,.speaker,.microphone,.headphones, .flash]
        self.imagesArray = ["sim", "carrier", "wifi", "battery", "display", "rear", "front", "vibrate", "touch", "earpiece", "speaker", "microphone", "headphone", "headphone"]
    }
}
