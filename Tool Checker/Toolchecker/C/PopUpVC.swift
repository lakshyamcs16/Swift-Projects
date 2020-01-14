//
//  PopUpVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 10/01/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//

import UIKit

enum status {
    case failed
    case success
}

class PopUpVC: UIViewController {

    @IBOutlet weak var statusSubLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var popupView: UIView!
    var state: status = .success
    var test: testNames = .none
    var timer = Timer()
    
    class func newInstance(state: status, source: testNames, tempText: String? = "") -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "PopUpVC") as? PopUpVC else {
            return UIViewController()
        }
        vc.state = state
        vc .test = source
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
                self.statusLabel.text = "Sim Card Present"
                self.statusSubLabel.isHidden = true
            } else {
                self.statusLabel.text = "Sim Card Not Present"
                self.statusSubLabel.isHidden = false
            }
        case .wifi:
            if state == .success {
                self.statusLabel.text = "Wifi Connected"
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .display:
            if state == .success {
                self.statusLabel.text = ""
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .rearCamera:
            if state == .success {
                self.statusLabel.text = "Rear Camera working"
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .frontCamera:
            if state == .success {
                self.statusLabel.text = "Front Camera working"
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .vibration:
            if state == .success {
                self.statusLabel.text = "Vibration working"
                self.statusSubLabel.isHidden = true
            } else {
                
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
            if state == .success {
                self.statusLabel.text = ""
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .microphone:
            if state == .success {
                self.statusLabel.text = ""
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .headphones:
            if state == .success {
                self.statusLabel.text = ""
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .charging:
            if state == .success {
                self.statusLabel.text = "Phone is charging"
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .flash:
            if state == .success {
                self.statusLabel.text = "Flash Light working"
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .motionSensor:
            if state == .success {
                self.statusLabel.text = "Motion Sensor working"
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
                    
            }
        case .proximitySensor:
            if state == .success {
                self.statusLabel.text = "Proximity Sensor working"
                self.statusSubLabel.isHidden = true
            } else {
                
            }
        case .none:
            break
        }
    }
    @objc func timeExpired() {
        self.dismiss(animated: false, completion: nil)
    }
}
