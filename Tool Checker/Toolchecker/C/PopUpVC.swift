//
//  PopUpVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 10/01/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//

import UIKit

enum Status {
    case failed
    case success
}

protocol PopupDelegate {
    func popupNextTest(check nextTestInQueue: testNames)
}

class PopUpVC: UIViewController {

    @IBOutlet weak var statusSubLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet var statusImage: UIImageView!
    @IBOutlet weak var popupView: UIView!
    var state: Status = .success
    var test: testNames = .none
    var nextTest: testNames = .none
    var tempText: String = ""
    var timer = Timer()
    var delegate: PopupDelegate?
    var tranistionCompleted: Bool = false
    
    class func newInstance(state: Status, source: testNames, tempText: String = "", next: testNames) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "PopUpVC") as? PopUpVC else {
            return UIViewController()
        }
        vc.state = state
        vc .test = source
        vc.tempText = tempText
        vc.nextTest = next
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.timeExpired), userInfo: nil, repeats: false)
        self.setUpVC()
    }

    func setUpVC() {
        switch test {
        case .simCard:
            if state == .success {
                self.statusLabel.text = "Sim Card present"
                self.statusSubLabel.isHidden = true
            } else {
                self.statusLabel.text = "Sim Card is not present"
                self.statusSubLabel.isHidden = false
                self.statusSubLabel.text = "Please insert sim card"
            }
        case .wifi:
            if state == .success {
                self.statusLabel.text = "Wifi Connected"
                self.statusSubLabel.isHidden = false
                self.statusSubLabel.text = "Your device is connected to wifi"
            } else {
                self.statusLabel.text = "Wifi is not connected"
                self.statusSubLabel.isHidden = false
                self.statusSubLabel.text = "Your device is not connected to wifi"
            }
        case .display:
            if state == .success {
                self.statusLabel.text = "Display is working fine"
                self.statusSubLabel.isHidden = true
            } else {
                self.statusLabel.text = "Display is not working fine"
                self.statusSubLabel.isHidden = false
                self.statusSubLabel.text = "Display does not seem to be in good condition"
            }
        case .rearCamera:
            if state == .success {
                self.statusLabel.text = "Rear Camera working"
                self.statusSubLabel.isHidden = true
            } else {
                self.statusLabel.text = "Rear Camera is not working"
                self.statusSubLabel.isHidden = false
                self.statusSubLabel.text = "Due to some technical reasons, we are unable to check Rear Camera. Please try after some time."

            }
        case .frontCamera:
            if state == .success {
                self.statusLabel.text = "Front Camera working"
                self.statusSubLabel.isHidden = true
            } else {
                self.statusLabel.text = "Front Camera is not working"
                self.statusSubLabel.isHidden = false
                self.statusSubLabel.text = "Due to some technical reasons, we are unable to check Front Camera. Please try after some time."
            }
        case .vibration:
            if state == .success {
                self.statusLabel.text = "Vibration working"
                self.statusSubLabel.isHidden = true
            } else {
                self.statusLabel.text = "Vibration is not working"
                self.statusSubLabel.isHidden = false
                self.statusSubLabel.text = "Vibration is not working, please get it checked."
            }
        case .touchScreen:
            if state == .success {
                self.statusLabel.text = ""
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .earpiece:
            if state == .success {
                self.statusLabel.text = ""
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .speaker:
            self.statusImage = UIImageView(image: UIImage(named: "speaker"))
            if state == .success {
                self.statusLabel.text = "Speakers are working"
                self.statusSubLabel.isHidden = true
            } else {
                self.statusLabel.text = "Speakers are not working"
                self.statusSubLabel.isHidden = false
                self.statusSubLabel.text = "Speakers are not working, please get them checked."
            }
        case .microphone:
            if state == .success {
                self.statusLabel.text = ""
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .headphones:
            if state == .success {
                self.statusLabel.text = "Headphone Jack is working"
                self.statusSubLabel.isHidden = true
            } else {
                self.statusLabel.text = "Headphone Jack is not working"
               self.statusSubLabel.isHidden = false
               self.statusSubLabel.text = "Headphone jack is not working properly, please try again or get it checked if it fails the test again."
            }
        case .charging:
            if state == .success {
                self.statusLabel.text = "Phone is charging"
                self.statusSubLabel.isHidden = false
                self.statusSubLabel.text = "Your device's current battery level is \(tempText)"
            } else {
                self.statusLabel.text = "Phone is not charging"
                self.statusSubLabel.isHidden = false
                self.statusSubLabel.text = "Please connect your device to a charger"
            }
        case .flash:
            if state == .success {
                self.statusLabel.text = "Flash Light working"
                self.statusSubLabel.isHidden = true
            } else {
                self.statusLabel.text = "Flash Light is not working"
                self.statusSubLabel.isHidden = false
                self.statusSubLabel.text = "Flash Light does not seem to be in good condition"
            }
        case .shakeGesture:
            if state == .success {
                self.statusLabel.text = "Shake Gesture working"
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .gyroscope:
            if state == .success {
                self.statusLabel.text = "Gyroscope Available"
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .buttons:
            if state == .success {
                self.statusLabel.text = "Buttons are working"
                self.statusSubLabel.isHidden = true
            } else {
                self.statusLabel.text = "Buttons are not working"
                self.statusSubLabel.isHidden = false
                self.statusSubLabel.text = "Due to some technical reasons, we are unable to check Proximity Sensor. Please try after some time."
            }
        case .proximitySensor:
            if state == .success {
                self.statusLabel.text = "Proximity Sensor working"
                self.statusSubLabel.isHidden = true
            } else {
                self.statusLabel.text = "Proximity Sensor is not working"
                self.statusSubLabel.isHidden = false
                self.statusSubLabel.text = "Due to some technical reasons, we are unable to check Proximity Sensor. Please try after some time."
            }
        case .none:
            break
        }
    }
    @objc func timeExpired() {
        self.dismissButtonTapped(self)
        if self.nextTest != .none && !self.tranistionCompleted {
            self.tranistionCompleted = true
            delegate?.popupNextTest(check: self.nextTest)
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        if self.nextTest != .none && !self.tranistionCompleted {
            self.tranistionCompleted = true
            delegate?.popupNextTest(check: self.nextTest)
        }
    }
}
