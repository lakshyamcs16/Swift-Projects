//
//  BatteryCheckVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 24/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit

class BatteryCheckVC: UIViewController {
    var sourceTest: testNames = .none
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    class func newInstance(sourceTest: testNames) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "BatteryCheckVC") as? BatteryCheckVC else {
            return UIViewController()
        }
        vc.sourceTest = sourceTest
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupVC()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

extension BatteryCheckVC {
    func setupVC() {
        switch self.sourceTest {
        case .charging:
            self.setBatteryVC()
        case .flash:
            self.setFlashVC()
        case .vibration:
            self.setVibrationVC()
        case .simCard:
            self.setSIMCardVC()
        case .frontCamera:
            self.setFrontCameraVC()
        case .rearCamera:
            self.setRearCameraVC()
        case .motionSensor:
            self.setMotionSensorScreen()
        case .touchScreen:
            self.setTouchScreenVC()
        case .wifi:
            self.setWifiVC()
        default:
            break
        }
    }
    
    func setBatteryVC() {
        self.nameLabel.text = "Charging"
        self.subtitle.text = "Plugin the charger to test your charging point"
        self.iconImage.image = UIImage(named: "battery")
        self.checkButton.setTitle("Check Connection", for: .normal)
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        print(UIDevice.current.batteryLevel)
        print(UIDevice.current.batteryState)
        //        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: NSNotification.Name.UIDevice.batteryLevelDidChangeNotification, object: nil)
        //
        //
        //        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: NSNotification.Name.UIDevice.batteryStateDidChangeNotification, object: nil)
        
        var batteryLevel: Float {
            return UIDevice.current.batteryLevel
        }
        
        var batteryState: UIDevice.BatteryState {
            return UIDevice.current.batteryState
        }
        
        func batteryLevelDidChange(_ notification: Notification) {
            print(batteryLevel)
        }
        
        func batteryStateDidChange(_ notification: Notification) {
            switch batteryState {
            case .unplugged, .unknown:
                print("not charging")
            case .charging, .full:
                print("charging or full")
            }
        }
    }
    
    func setFlashVC() {
        self.nameLabel.text = "Flash"
        self.subtitle.text = "Tap to check Flash Light"
        self.iconImage.image = UIImage(named: "battery")
        self.checkButton.setTitle("Check Flash", for: .normal)
    }
    
    func setVibrationVC() {
        self.nameLabel.text = "Vibration"
        self.subtitle.text = "Tap to check Vibration"
        self.iconImage.image = UIImage(named: "vibrate")
        self.checkButton.setTitle("Check to Vibrate", for: .normal)
    }
    
    func setSIMCardVC() {
        self.nameLabel.text = "Sim Card"
        self.subtitle.text = "Tap to check whether Sim Card is inserted or not"
        self.iconImage.image = UIImage(named: "sim")
        self.checkButton.setTitle("Check Sim Card", for: .normal)
    }
    
    func setFrontCameraVC() {
        self.nameLabel.text = "Front Camera"
        self.subtitle.text = "Tap to check whether Front Camera is working or not"
        self.iconImage.image = UIImage(named: "front")
        self.checkButton.setTitle("Check Front Camera", for: .normal)
    }
    func setRearCameraVC() {
        self.nameLabel.text = "Rear Camera"
        self.subtitle.text = "Tap to check whether Rear Camera is working or not"
        self.iconImage.image = UIImage(named: "rear")
        self.checkButton.setTitle("Check Rear Camera", for: .normal)
    }
    func setTouchScreenVC() {
        self.nameLabel.text = "Touch Screen"
        self.subtitle.text = "Tap to check whether Touch Screen is working or not"
        self.iconImage.image = UIImage(named: "touch")
        self.checkButton.setTitle("Run Test", for: .normal)
    }
    func setMotionSensorScreen() {
        self.nameLabel.text = "MotionSensor"
        self.subtitle.text = "Tap to check whether Motion Sensor is working or not"
        self.iconImage.image = UIImage(named: "touch")
        self.checkButton.setTitle("Check Sensore", for: .normal)
    }
    func setWifiVC() {
        self.nameLabel.text = "WiFi"
        self.subtitle.text = "Tap to check whether phone is connected to WiFi or not"
        self.iconImage.image = UIImage(named: "wifi")
        self.checkButton.setTitle("Check WiFi Connection", for: .normal)
    }
}
