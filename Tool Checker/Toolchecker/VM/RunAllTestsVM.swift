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
    case charging
    case flash
    case motionSensor
    case none
}

class RunAllTestsVM {
    var array: [testNames] = []
    var imagesArray:[String] = []
    
    init() {
        self.array = [.simCard, .mobileCarrier, .wifi,.charging, .display,.rearCamera,.frontCamera,.vibration,.touchScreen,.earpiece,.speaker,.microphone,.headphones, .flash]
        self.imagesArray = ["sim", "carrier", "wifi", "battery", "display", "rear", "front", "vibrate", "touch", "earpiece", "speaker", "microphone", "headphone", "headphone"]
    }
}
