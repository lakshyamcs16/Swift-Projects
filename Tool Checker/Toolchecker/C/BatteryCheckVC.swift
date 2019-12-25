//
//  BatteryCheckVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 24/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit

class BatteryCheckVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.isBatteryMonitoringEnabled = true
        print(UIDevice.current.batteryLevel)
        print(UIDevice.current.batteryState)        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    
    var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    var batteryState: UIDevice.BatteryState {
        return UIDevice.current.batteryState
    }
    
    @objc func batteryLevelDidChange(_ notification: Notification) {
        print(batteryLevel)
    }
    
    @objc func batteryStateDidChange(_ notification: Notification) {
        switch batteryState {
        case .unplugged, .unknown:
            print("not charging")
        case .charging, .full:
            print("charging or full")
        }
    }

}
