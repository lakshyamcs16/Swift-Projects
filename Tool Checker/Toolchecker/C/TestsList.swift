//
//  TestsList.swift
//  Toolchecker
//
//  Created by Aashna Narula on 19/01/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//

import UIKit

class Tests {
    static func allTests(key: testNames, this: UINavigationController, runAllTests: Bool) {
        switch key {
        case .simCard:
            let vc = BatteryCheckVC.newInstance(sourceTest: .simCard, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
        case .wifi:
            let vc = BatteryCheckVC.newInstance(sourceTest: .wifi, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
        case .display:
            let vc = BatteryCheckVC.newInstance(sourceTest: .display, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
            break
        case .rearCamera:
            let vc = BatteryCheckVC.newInstance(sourceTest: .rearCamera, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
        case .frontCamera:
            let vc = BatteryCheckVC.newInstance(sourceTest: .frontCamera, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
        case .vibration:
            let vc = BatteryCheckVC.newInstance(sourceTest: .vibration, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
        case .touchScreen:
            let vc = BatteryCheckVC.newInstance(sourceTest: .touchScreen, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
        case .earpiece:
            break
        case .speaker:
            let vc = BatteryCheckVC.newInstance(sourceTest: .speaker, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
        case .microphone:
            let vc = MicrophoneCheckVC.newInstance()
            this.pushViewController(vc, animated: true)
        case .headphones:
            let vc = BatteryCheckVC.newInstance(sourceTest: .headphones, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
            break
        case .charging:
            let vc = BatteryCheckVC.newInstance(sourceTest: .charging, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
        case .flash:
            let vc = BatteryCheckVC.newInstance(sourceTest: .flash, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
        case .motionSensor:
            let vc = BatteryCheckVC.newInstance(sourceTest: .motionSensor, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
        case .buttons:
            let vc = BatteryCheckVC.newInstance(sourceTest: .buttons, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
        case .gyroscope:
            let vc = GyroscopeTestVC.newInstance()
            this.pushViewController(vc, animated: true)
        case .proximitySensor:
            let vc = BatteryCheckVC.newInstance(sourceTest: .proximitySensor, runAll: runAllTests)
            this.pushViewController(vc, animated: true)
        default:
            break
        }
        
        
    }
    
    
}
