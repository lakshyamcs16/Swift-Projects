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
            let alert = UIAlertController(title: "Alert", message: "Front camera working", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .rearCamera:
            guard (AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back).devices.filter({ $0.position == .back }).first) != nil else {
                print("No back facing camera found")
                return
            }
            let alert = UIAlertController(title: "Alert", message: "Back camera working", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .motionSensor:
            self.setMotionSensorScreen()
        case .display:
            self.checkDisplay()
        case .touchScreen:
            self.checkTouch()
        case .wifi:
            if Reachability.isConnectedToNetwork(){
                let alert = UIAlertController(title: "Alert", message: "Wifi connected", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Alert", message: "Wifi not connected", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        case .headphones:
            self.checkHeadphones()
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
        case .display:
            self.setDisplayScreenVC()
        case .wifi:
            self.setWifiVC()
        case .headphones:
            self.setHeadphones()
        default:
            break
        }
    }
    
    func activateHeadPhonesStatus(){
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleRouteChange),
                                       name: .AVAudioSessionRouteChange,
                                       object: nil)
    }
    
    @objc func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSessionRouteChangeReason(rawValue:reasonValue) else {
                return
        }
        switch reason {
        case .newDeviceAvailable:
            let session = AVAudioSession.sharedInstance()
            for output in session.currentRoute.outputs where output.portType == AVAudioSessionPortHeadphones {
                print("Connection")
                break
            }
        case .oldDeviceUnavailable:
            if let previousRoute =
                userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                for output in previousRoute.outputs where output.portType == AVAudioSessionPortHeadphones {
                    print("Not Connected")
                    break
                }
            }
        default: ()
        }
    }
    
    func checkHeadphones() {
        activateHeadPhonesStatus()
    }
    
    func setHeadphones() {
        self.nameLabel.text = "Headphones"
        self.subtitle.text = """
                                Please connect headphones to device. Connection should be automatically
                                detected. \n
                                If pass result pop-up does not appear, tap the Check connection button.
                             """
        self.iconImage.image = UIImage(named: "headphones")
        self.checkButton.setTitle("Headphones", for: .normal)
    }
    
    func checkDisplay() {
        self.navigationController?.pushViewController(DisplayCheckViewController.newInstance(), animated: true)
    }
    
    func checkTouch() {
        self.navigationController?.pushViewController(TouchViewController.newInstance(), animated: true)
    }
    
    func setDisplayScreenVC() {
        self.nameLabel.text = "Display"
        self.subtitle.text = """
                                The next screens will display a series of color
                                (black, white, green, red, and blue). Look carefully for dead or
                                stuck pixels or any discoloration.
                                \n
                                Tap the screen when you're ready for the next color.
                                """
        self.iconImage.image = UIImage(named: "display")
        self.checkButton.setTitle("Check Display", for: .normal)
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
        
        var batteryState: UIDeviceBatteryState {
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
            let alert = UIAlertController(title: "Alert", message: "Sim present", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Sim not present", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
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
        self.subtitle.text = """
                                On the next screen, drag your finger over the screen until the whole
                                content turns green. \n
                                You have 20 seconds to complete the test
                            """
        self.iconImage.image = UIImage(named: "touch")
        self.checkButton.setTitle("Run Touch Test", for: .normal)
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
