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
    
    init() {
        self.array = [.simCard, .mobileCarrier, .wifi,.display,.rearCamera,.frontCamera,.vibration,.touchScreen,.earpiece,.speaker,.microphone,.headphones]
    }
}
