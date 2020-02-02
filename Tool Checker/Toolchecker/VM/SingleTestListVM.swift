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
        self.array = [.simCard, .wifi,.charging, .display,.rearCamera,.frontCamera,.vibration,.touchScreen,.speaker,.microphone,.headphones, .flash, .gyroscope, .shakeGesture, .proximitySensor]
    }
}
