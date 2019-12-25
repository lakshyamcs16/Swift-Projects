//
//  RunAllTestsVM.swift
//  Toolchecker
//
//  Created by Aashna Narula on 23/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import Foundation

enum testNames {
    case simCard
    case mobileCarrier
    case wifi
    case display
    case rearCamera
    case frontCamera
    case vibration
    case touchScreen
    case earpiece
    case speaker
    case microphone
    case headphones
}

class RunAllTestsVM {
    var array: [testNames] = []
    
    init() {
        self.array = [.simCard, .mobileCarrier, .wifi,.display,.rearCamera,.frontCamera,.vibration,.touchScreen,.earpiece,.speaker,.microphone,.headphones]
    }
}
