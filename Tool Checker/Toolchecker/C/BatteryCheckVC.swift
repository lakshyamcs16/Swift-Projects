//
//  BatteryCheckVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 24/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

/*
 Bugs/Enhancements:
 1. Run all tests: when back button is pressed, it should take to the beginning of the previous test in all case
 */

import UIKit
import CoreTelephony
import SystemConfiguration
import AVFoundation
import AudioToolbox

class BatteryCheckVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DisplayCheckVCDelegate, PopupDelegate {
    var sourceTest: testNames = .none
    var nextTest: testNames = .none
    var result:Bool = false
    var imagePicker: UIImagePickerController!
    var hasDisplayCheckCompleted: Bool = false
    var runAllTests: Bool = false
    var status: Status = .failed
    var count: Int = 0
    var timer: Timer?
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    var player: AVAudioPlayer?
    
    class func newInstance(sourceTest: testNames, runAll: Bool) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "BatteryCheckVC") as? BatteryCheckVC else {
            return UIViewController()
        }
        vc.sourceTest = sourceTest
        vc.runAllTests = runAll
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        self.setupVC(key: self.sourceTest)
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
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
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
            self.nextTest = Tests.getNextTest(next: .vibration, run: self.runAllTests)
            guard (AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.front).devices.filter({ $0.position == .front }).first) != nil else {
                if let vc = PopUpVC.newInstance(state: .failed, source: .frontCamera, next: nextTest) as? PopUpVC {
                    vc.delegate = self
                    vc.modalPresentationStyle = .custom
                    self.present(vc, animated: true, completion:  nil)
                }
                return
            }
            self.openCamera()
            
        case .rearCamera:
            self.nextTest = Tests.getNextTest(next: .frontCamera, run: self.runAllTests)

            guard (AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back).devices.filter({ $0.position == .back }).first) != nil else {
                if let vc = PopUpVC.newInstance(state: .failed, source: .rearCamera, next: nextTest) as? PopUpVC {
                    vc.delegate = self
                    vc.modalPresentationStyle = .custom
                    self.present(vc, animated: true, completion:  nil)
                }
                return;
            }
            self.openCamera()
            
        case .shakeGesture:
            self.checkShakeGesture()
        case .display:
            self.checkDisplay()
        case .touchScreen:
            self.checkTouch()
        case .wifi:
            self.checkWifi()
        case .speaker:
            self.playSound()
        case .headphones:
            self.checkHeadphones()
        case .proximitySensor:
            self.checkProximitySensor()
        default:
            break
        }
    }
    
    func openCamera() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let vc = PopUpVC.newInstance(state: .success, source: .rearCamera, next: self.nextTest) as? PopUpVC {
            vc.delegate = self
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion:  nil)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

extension BatteryCheckVC {
    func checkShakeGesture(state: Status = .failed) {
        var next: testNames = .none
        if self.runAllTests {
            next = .proximitySensor
        }
        
        if let vc = PopUpVC.newInstance(state: state, source: .shakeGesture, next: next) as? PopUpVC {
            vc.delegate = self
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion:  nil)
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.checkShakeGesture(state: .success)
        } else {
            self.checkShakeGesture(state: .failed)
        }
    }
    
    
    
    func checkDisplay() {
        let goNext = storyboard?.instantiateViewController(withIdentifier: "displayCheckVC") as! DisplayCheckViewController
        goNext.delegate = self
        self.navigationController?.pushViewController(goNext, animated: true)
    }
    
    func checkTouch() {
        self.navigationController?.pushViewController(TouchViewController.newInstance(runAllTests: self.runAllTests), animated: true)
    }
    
    
    func checkHeadphones() {
        let session = AVAudioSession.sharedInstance()
        let currentRoute = session.currentRoute
        var next: testNames = .none
        if self.runAllTests {
            next = .flash
        }
        if currentRoute.outputs.count != 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSession.Port.headphones {
                    print("headphone plugged in")
                        Tests.createPopVC(status: .success, source: .headphones, next: next, this: self)
                } else {
                    print("headphone pulled out")
                        Tests.createPopVC(status: .failed, source: .headphones, next: next, this: self)
                }
            }
        } else {
            print("requires connection to device")
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.audioRouteChangeListener(_:)),
            name: AVAudioSession.routeChangeNotification,
            object: nil)
    }
    
    @objc func audioRouteChangeListener(_ notification:NSNotification) {
        guard let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as? UInt else { return }
        var next: testNames = .none
        if self.runAllTests {
            next = .flash
        }
        switch audioRouteChangeReason {
        case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
            print("headphone plugged in")
                Tests.createPopVC(status: .success, source: .headphones, next: next, this: self)
        case AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue:
            print("headphone pulled out")
                Tests.createPopVC(status: .failed, source: .headphones, next: next, this: self)
        default:
            break
        }
    }
    
    
    var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    var batteryState: UIDevice.BatteryState{
        return UIDevice.current.batteryState
    }
    
    @objc func batteryLevelDidChange(_ notification: Notification) {
        print(batteryLevel)
    }
    
    @objc func batteryStateDidChange(_ notification: Notification) {
        self.nextTest = Tests.getNextTest(next: .display, run: self.runAllTests)
        
        switch batteryState {
            case .unplugged, .unknown:
                self.status = .failed
            case .charging, .full:
                self.status = .success
        }
        
        if let vc = PopUpVC.newInstance(state: self.status, source: .charging, tempText: String(batteryLevel), next: nextTest) as? PopUpVC {
            vc.delegate = self
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion:  nil)
        }
    }
    
    
    func checkBatteryStatus() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        print(UIDevice.current.batteryLevel)
        print(UIDevice.current.batteryState)
        
        self.nextTest = Tests.getNextTest(next: .display, run: self.runAllTests)
        
        if UIDevice.current.batteryLevel == -1 {
            if let vc = PopUpVC.newInstance(state: .failed, source: .charging, tempText: "", next: nextTest) as? PopUpVC {
                vc.delegate = self
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion:  nil)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    
    func checkSimCardAvailability() {
        let networkInfo = CTTelephonyNetworkInfo()
        self.nextTest = Tests.getNextTest(next: .wifi, run: self.runAllTests)
        self.status = .failed
        
        guard let info = networkInfo.subscriberCellularProvider else {
            if let vc = PopUpVC.newInstance(state: self.status, source: .simCard, next: self.nextTest) as? PopUpVC {
                vc.delegate = self
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion:  nil)
            }
            return
        }
        
        if info.isoCountryCode != nil {
            self.status = .success
        }
        
        if let vc = PopUpVC.newInstance(state: self.status, source: .simCard, next: self.nextTest) as? PopUpVC {
            vc.delegate = self
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: false, completion:  nil)
        }
    }
    
    func checkWifi() {
        self.nextTest = Tests.getNextTest(next: .charging, run: self.runAllTests)
        self.status = .failed
        if Reachability.isConnectedToNetwork(){
            self.status = .success
        }
        
        if let vc = PopUpVC.newInstance(state: self.status, source: .wifi, next: nextTest) as? PopUpVC {
            vc.delegate = self
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion:  nil)
        }
    }
    
    
    func setMicrophoneVC() {
        var vcNext = MicrophoneCheckVC.newInstance(nextTest: .none)
        
        if self.runAllTests {
            vcNext = MicrophoneCheckVC.newInstance(nextTest: .headphones)
        }
        
        self.navigationController?.pushViewController(vcNext, animated: true)
    }
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "testtone", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player?.play()

            self.nextTest = Tests.getNextTest(next: .microphone, run: self.runAllTests)



            let alert = UIAlertController(title: "Speaker Test", message: "Did you hear the sound?", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .default) { UIAlertAction in
                    self.player?.stop()
                    if let vc = PopUpVC.newInstance(state: .success, source: .speaker, next: self.nextTest) as? PopUpVC {
                        vc.delegate = self
                        vc.modalPresentationStyle = .custom
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                let noAction = UIAlertAction(title: "No", style: .default) { UIAlertAction in
                    self.player?.stop()
                    if let vc = PopUpVC.newInstance(state: .failed, source: .speaker, next: self.nextTest) as? PopUpVC {
                       vc.delegate = self
                       vc.modalPresentationStyle = .custom
                        self.present(vc, animated: true, completion: nil)
                   }
                }
                alert.addAction(yesAction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)
            
        } catch let error {
            print("hi")
            print(error.localizedDescription)
        }
    }
    
    
    
    func switchOnFlashLight() {
        self.nextTest = Tests.getNextTest(next: .gyroscope, run: self.runAllTests)

        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            if let vc = PopUpVC.newInstance(state: .error, source: .flash, next: self.nextTest) as? PopUpVC {
                vc.delegate = self
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion:  nil)
            }
            return
        }
        guard device.hasTorch else { return }
               do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                self.checkButton.setTitle("Check Flash", for: .normal)
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                    self.checkButton.setTitle("Switch off flash light", for: .normal)
                    if let vc = PopUpVC.newInstance(state: .success, source: .flash, next: self.nextTest) as? PopUpVC {
                        vc.delegate = self
                        vc.modalPresentationStyle = .custom
                        self.present(vc, animated: true, completion:  nil)
                    }
                } catch {
                    if let vc = PopUpVC.newInstance(state: .failed, source: .flash, next: self.nextTest) as? PopUpVC {
                        vc.delegate = self
                        vc.modalPresentationStyle = .custom
                        self.present(vc, animated: true, completion:  nil)
                    }
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            if let vc = PopUpVC.newInstance(state: .failed, source: .flash, next: self.nextTest) as? PopUpVC {
                vc.delegate = self
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion:  nil)
            }
            print(error)
        }
    }
    
    func switchOnVibration() {
           self.nextTest = Tests.getNextTest(next: .touchScreen, run: self.runAllTests)
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {
         Tests.createAlert(title: "Vibration Check", message: "Did you feel the vibration?", this: self, source: .vibration)
        }
       
    }
    
    private func startTimer() {
        self.stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.showAlert), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    @objc func showAlert() {
           self.stopTimer()
           let alert = UIAlertController(title: "Timeout!", message: "We could not detect any sensation. Do you want to try again?", preferredStyle: .alert)
           let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
               UIAlertAction in
               self.startTimer()
           }
           let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
               UIAlertAction in
               if let vc = PopUpVC.newInstance(state: .failed, source: .proximitySensor, next: .none) as? PopUpVC {
                    vc.delegate = self
                    vc.modalPresentationStyle = .custom
                    self.present(vc, animated: true, completion:  nil)
                }
        }
           alert.addAction(yesAction)
           alert.addAction(noAction)
           self.present(alert, animated: true, completion: nil)
    }
    func checkProximitySensor() {
        self.startTimer()
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: Selector(("proximityChanged")), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Wave your hand to check if Proximity Sensor is working or not", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func proximityChanged(notification: NSNotification) {
        if let device = notification.object as? UIDevice {
            print("\(device) detected!")
            if let vc = PopUpVC.newInstance(state: .success, source: .proximitySensor, next: .none) as? PopUpVC {
                vc.delegate = self
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion:  nil)
            }
        }
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

extension BatteryCheckVC {
    func DisplayCheckControllerResponse(check hasCheckCompleted: Bool) {
        self.hasDisplayCheckCompleted = hasCheckCompleted
        self.nextTest = Tests.getNextTest(next: .rearCamera, run: self.runAllTests)
        if hasDisplayCheckCompleted {
            hasDisplayCheckCompleted = false
            Tests.createAlert(title: "Display Check", message: "Was the screen free of dead or stuck pixels?", this: self, source: .display)
        };
        
        
    }
    
}

extension BatteryCheckVC {
    func popupNextTest(check nextTestInQueue: testNames) {
        self.sourceTest = nextTestInQueue
        self.setupVC(key: self.sourceTest)
    }
}

// ---------------------------------SetupVC----------------------------------

extension BatteryCheckVC {
    func setupVC(key: testNames) {
        switch key {
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
        case .shakeGesture:
            self.setShakeGestureScreen()
        case .touchScreen:
            self.setTouchScreenVC()
        case .display:
            self.setDisplayScreenVC()
        case .wifi:
            self.setWifiVC()
        case .speaker:
            self.setSpeakerVC()
        case .microphone:
            self.setMicrophoneVC()
        case .headphones:
            self.setHeadphonesVC()
        case .proximitySensor:
            self.setProximitySensorVC()
        case .gyroscope:
            Tests.allTests(key: .gyroscope, this: self.navigationController, runAllTests: self.runAllTests)
        default:
            break
        }
    }
    
    func setBatteryVC() {
        Setups.setupVCScreen(this: self, name: StringConstants.BATTERY["name"] as! String, subtitle: StringConstants.BATTERY["subtitle"] as! String, image: StringConstants.BATTERY["image"] as! String, button: StringConstants.BATTERY["button"] as! String);
    }
    
    func setFlashVC() {
        Setups.setupVCScreen(this: self, name: StringConstants.FLASH["name"] as! String, subtitle: StringConstants.FLASH["subtitle"] as! String, image: StringConstants.FLASH["image"] as! String, button: StringConstants.FLASH["button"] as! String);
    }
    
    func setVibrationVC() {
        Setups.setupVCScreen(this: self, name: StringConstants.VIBRATE["name"] as! String, subtitle: StringConstants.VIBRATE["subtitle"] as! String, image: StringConstants.VIBRATE["image"] as! String, button: StringConstants.VIBRATE["button"] as! String);
    }
    
    func setSIMCardVC() {
        Setups.setupVCScreen(this: self, name: StringConstants.SIMCARD["name"] as! String, subtitle: StringConstants.SIMCARD["subtitle"] as! String, image: StringConstants.SIMCARD["image"] as! String, button: StringConstants.SIMCARD["button"] as! String);
    }
    
    func setFrontCameraVC() {
        Setups.setupVCScreen(this: self, name: StringConstants.FRONTCAMERA["name"] as! String, subtitle: StringConstants.FRONTCAMERA["subtitle"] as! String, image: StringConstants.FRONTCAMERA["image"] as! String, button: StringConstants.FRONTCAMERA["button"] as! String);
    }
    
    func setRearCameraVC() {
        Setups.setupVCScreen(this: self, name: StringConstants.REARCAMERA["name"] as! String, subtitle: StringConstants.REARCAMERA["subtitle"] as! String, image: StringConstants.REARCAMERA["image"] as! String, button: StringConstants.REARCAMERA["button"] as! String);
    }
    
    func setShakeGestureScreen() {
        Setups.setupVCScreen(this: self, name: StringConstants.SHAKE["name"] as! String, subtitle: StringConstants.SHAKE["subtitle"] as! String, image: StringConstants.SHAKE["image"] as! String, button: StringConstants.SHAKE["button"] as! String);
    }
    
    func setTouchScreenVC() {
        Setups.setupVCScreen(this: self, name: StringConstants.TOUCHSCREEN["name"] as! String, subtitle: StringConstants.TOUCHSCREEN["subtitle"] as! String, image: StringConstants.TOUCHSCREEN["image"] as! String, button: StringConstants.TOUCHSCREEN["button"] as! String);
    }
    
    func setDisplayScreenVC() {
        Setups.setupVCScreen(this: self, name: StringConstants.DISPLAY["name"] as! String, subtitle: StringConstants.DISPLAY["subtitle"] as! String, image: StringConstants.DISPLAY["image"] as! String, button: StringConstants.DISPLAY["button"] as! String);
    }
    
    func setWifiVC() {
        Setups.setupVCScreen(this: self, name: StringConstants.WIFI["name"] as! String, subtitle: StringConstants.WIFI["subtitle"] as! String, image: StringConstants.WIFI["image"] as! String, button: StringConstants.WIFI["button"] as! String);
    }
    
    func setSpeakerVC() {
        Setups.setupVCScreen(this: self, name: StringConstants.SPEAKER["name"] as! String, subtitle: StringConstants.SPEAKER["subtitle"] as! String, image: StringConstants.SPEAKER["image"] as! String, button: StringConstants.SPEAKER["button"] as! String);
    }
    
    func setHeadphonesVC() {
        Setups.setupVCScreen(this: self, name: StringConstants.HEADPHONES["name"] as! String, subtitle: StringConstants.HEADPHONES["subtitle"] as! String, image: StringConstants.HEADPHONES["image"] as! String, button: StringConstants.HEADPHONES["button"] as! String);
    }
    
    func setProximitySensorVC() {
        Setups.setupVCScreen(this: self, name: StringConstants.PROXIMITY["name"] as! String, subtitle: StringConstants.PROXIMITY["subtitle"] as! String, image: StringConstants.PROXIMITY["image"] as! String, button: StringConstants.PROXIMITY["button"] as! String);
    }
}
