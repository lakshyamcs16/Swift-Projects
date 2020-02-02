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
    case wifi
    case display
    case rearCamera
    case frontCamera
    case vibration
    case touchScreen
    case speaker
    case microphone
    case headphones
    case charging
    case flash
    case shakeGesture
    case gyroscope
    case proximitySensor
    case none
}

class RunAllTestsVM {
    var array: [testNames] = []
    var imagesArray:[String] = []
    
    init() {
        self.array = [.simCard, .wifi,.charging, .display,.rearCamera,.frontCamera,.vibration,.touchScreen,.speaker,.microphone,.headphones, .flash, .gyroscope, .proximitySensor]
        self.imagesArray = ["sim", "wifi", "battery", "display", "rear", "front", "vibrate", "touch", "speaker", "microphone", "headphone", "flash", "gyroscope", "proximity"]
    }
}
