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

class BatteryCheckVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DisplayCheckVCDelegate {
    var sourceTest: testNames = .none
    var result:Bool = false
    var imagePicker: UIImagePickerController!
    var hasDisplayCheckCompleted: Bool = false
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    var player: AVAudioPlayer?
    
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
                let vc = PopUpVC.newInstance(state: .failed, source: .frontCamera)
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion:  nil)
                return
            }
            self.openCamera()
            let vc = PopUpVC.newInstance(state: .success, source: .frontCamera)
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion:  nil)
        case .rearCamera:
            guard (AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back).devices.filter({ $0.position == .back }).first) != nil else {
                let vc = PopUpVC.newInstance(state: .failed, source: .rearCamera)
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion:  nil)
                return
            }
            self.openCamera()
            let vc = PopUpVC.newInstance(state: .success, source: .rearCamera)
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion:  nil)
        case .motionSensor:
            self.setMotionSensorScreen()
        case .display:
            self.checkDisplay()
        case .touchScreen:
            self.checkTouch()
        case .wifi:
            if Reachability.isConnectedToNetwork(){
                let vc = PopUpVC.newInstance(state: .success, source: .wifi)
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion:  nil)
            }else{
                let vc = PopUpVC.newInstance(state: .failed, source: .wifi)
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion:  nil)
            }
        case .speaker:
            self.playSound()
        case .headphones:
            self.checkHeadphones()
        case .buttons:
            self.listenVolumeButton()
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
        imagePicker.dismiss(animated: true, completion: nil)
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
        case .speaker:
            self.setSpeakerVC()
        case .microphone:
            self.setMicrophoneVC()
        case .headphones:
            self.setHeadphonesVC()
        case .buttons:
            self.setButtonsVC()
        case .proximitySensor:
            self.setProximitySensorVC()
        default:
            break
        }
    }
    
    func setProximitySensorVC() {
        self.nameLabel.text = "Proximity Sensor"
        self.subtitle.text = "Tap to check Proximity Sensor"
        self.iconImage.image = UIImage(named: "battery")
        self.checkButton.setTitle("Check Sensor", for: .normal)
    }
    
    func checkDisplay() -> status {
        var state: status = .failed
        if hasDisplayCheckCompleted {
            hasDisplayCheckCompleted = false
            let alert = UIAlertController(title: "Display Check", message: "Was the screen free of dead or stuck pixels?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) {
                UIAlertAction in
                state = .success
            }
            let noAction = UIAlertAction(title: "No", style: .default) {
                UIAlertAction in
                state = .failed
            }
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
        };
        
        let goNext = storyboard?.instantiateViewController(withIdentifier: "displayCheckVC") as! DisplayCheckViewController
        goNext.delegate = self
        self.navigationController?.pushViewController(goNext, animated: true)
        return state
    }
    
    func checkTouch() {
        self.navigationController?.pushViewController(TouchViewController.newInstance(), animated: true)
    }
    
    func listenVolumeButton() {
        let audioSession = AVAudioSession()
        do {
            try audioSession.setActive(true)
        } catch {
            print("some error")
        }
        audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            print("got in here")
        }
    }
    
    func checkHeadphones() {
        let session = AVAudioSession.sharedInstance()
        let currentRoute = session.currentRoute
        if currentRoute.outputs.count != 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSession.Port.headphones {
                    print("headphone plugged in")
                } else {
                    print("headphone pulled out")
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
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        
        switch audioRouteChangeReason {
        case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
            print("headphone plugged in")
        case AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue:
            print("headphone pulled out")
        default:
            break
        }
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
        switch batteryState {
        case .unplugged, .unknown:
            let vc = PopUpVC.newInstance(state: .failed, source: .charging)
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion:  nil)
        case .charging, .full:
            let vc = PopUpVC.newInstance(state: .success, source: .charging, tempText: String(batteryLevel))
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion:  nil)
        }
    }
    
    
    func checkBatteryStatus() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        print(UIDevice.current.batteryLevel)
        print(UIDevice.current.batteryState)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
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
        self.subtitle.text = "Tap to check whether Sim Card is present or not"
        self.iconImage.image = UIImage(named: "sim")
        self.checkButton.setTitle("Check Sim Card", for: .normal)
    }
    
    func checkSimCardAvailability() {
        let networkInfo = CTTelephonyNetworkInfo()
        guard let info = networkInfo.subscriberCellularProvider else {return}
        if info.isoCountryCode != nil {
            let vc = PopUpVC.newInstance(state: .success, source: .simCard)
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion:  nil)
        } else {
            let vc = PopUpVC.newInstance(state: .failed, source: .simCard)
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion:  nil)
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
    
    func setSpeakerVC() {
        self.nameLabel.text = "Speaker Test"
        self.subtitle.text = "Tap on Check Speakers button to hear the sound"
        self.iconImage.image = UIImage(named: "speaker")
        self.checkButton.setTitle("Check Speakers", for: .normal)
    }
    
    func setMicrophoneVC() {
        self.nameLabel.text = "Microphone Test"
        self.subtitle.text = "Tap on Record button to record the audio"
        self.iconImage.image = UIImage(named: "microphone")
        self.checkButton.setTitle("Record", for: .normal)
    }
    
    func setHeadphonesVC() {
        self.nameLabel.text = "Headphone Jack test"
        self.subtitle.text = "Plugin the headphones and wait for the notification. If no notification is shown, headphone jack might be faulty"
        self.iconImage.image = UIImage(named: "headphone")
        self.checkButton.setTitle("Check Headphone", for: .normal)
    }
    
    func setButtonsVC() {
        self.nameLabel.text = "Buttons test"
        self.subtitle.text = "Press volume and power button one by one to complete the test"
        self.iconImage.image = UIImage(named: "headphone")
        self.checkButton.setTitle("<<Checkbox needs to be added>>", for: .normal)
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "testtone", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)            
            let player = try AVAudioPlayer(contentsOf: url)
            
            player.play()
            
            let alert = UIAlertController(title: "Speaker Test", message: "Did you hear the sound?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
                print("Passed")
            }
            let noAction = UIAlertAction(title: "No", style: .default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
                print("Failed")
            }
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } catch let error {
            print(error.localizedDescription)
        }
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
    
    func checkProximitySensor() {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: Selector(("proximityChanged")), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Wave your hand to check if Proximity Sensor is working or not", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func proximityChanged(notification: NSNotification) {
        if let device = notification.object as? UIDevice {
            print("\(device) detected!")
            let vc = PopUpVC.newInstance(state: .success, source: .proximitySensor)
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion:  nil)
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
        var res = self.checkDisplay()
        let vc = PopUpVC.newInstance(state: res, source: .charging)
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion:  nil)
    }
}
