//
//  BatteryCheckVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 24/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit
import CoreTelephony
import SystemConfiguration
import AVFoundation
import AudioToolbox

class BatteryCheckVC: UIViewController {
    var sourceTest: testNames = .none
    var result:Bool = false
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
    
    
    @IBAction func checkConnectionButtonTapped(_ sender: Any) {
        switch self.sourceTest {
        case .charging:
            self.checkBatteryStatus()
        case .flash:
            self.switchOnFlashLight()
        case .vibration:
            self.switchOnVibration()
        case .simCard:
            self.checkSimCardAvailability()
        case .frontCamera:
            guard (AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.front).devices.filter({ $0.position == .front }).first) != nil else {
                    print("No front facing camera found")
                return
            }
            let alert = UIAlertController(title: "Alert", message: "Front camera working", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .rearCamera:
            guard (AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back).devices.filter({ $0.position == .back }).first) != nil else {
                print("No back facing camera found")
                return
            }
            let alert = UIAlertController(title: "Alert", message: "Back camera working", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .motionSensor:
            self.setMotionSensorScreen()
        case .touchScreen:
            break
        case .wifi:
            if Reachability.isConnectedToNetwork(){
                let alert = UIAlertController(title: "Alert", message: "Wifi connected", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Alert", message: "Wifi not connected", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        default:
            break
        }
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
    }
    
    func checkBatteryStatus() {
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
    
    func checkSimCardAvailability() {
        let networkInfo = CTTelephonyNetworkInfo()
        guard let info = networkInfo.subscriberCellularProvider else {return}
        if let carrier = info.isoCountryCode {
            let alert = UIAlertController(title: "Alert", message: "Sim present", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Sim not present", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
        self.checkButton.setTitle("Check Sensor", for: .normal)
    }
    func setWifiVC() {
        self.nameLabel.text = "WiFi"
        self.subtitle.text = "Tap to check whether phone is connected to WiFi or not"
        self.iconImage.image = UIImage(named: "wifi")
        self.checkButton.setTitle("Check WiFi Connection", for: .normal)
    }
    
    func switchOnFlashLight() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    func switchOnVibration() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        return isReachable && !needsConnection
    }
}
