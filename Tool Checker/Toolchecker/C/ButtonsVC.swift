//
//  ButtonsVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 30/01/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//

import UIKit
import AVFoundation

class ButtonsVC: UIViewController {

    @IBOutlet weak var powerImage: UIImageView!
    var nextTest: testNames = .none
    class func newInstance(nextTest: testNames) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ButtonsCheckVC") as? ButtonsVC else {
            return UIViewController()
        }
        vc.nextTest = nextTest
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listenVolumeButton()
        self.applicationDidEnterBackground()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ButtonsVC {
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
    
    func applicationDidEnterBackground() {
        if (DidUserPressLockButton()) {
            print("User pressed lock button")
        } else {
            print("user pressed home button")
            powerImage.image = UIImage(named: "checkmark")
        }
    }

    private func DidUserPressLockButton() -> Bool {
        let oldBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = oldBrightness + (oldBrightness <= 0.01 ? (0.01) : (-0.01))
        return oldBrightness != UIScreen.main.brightness
    }
}
