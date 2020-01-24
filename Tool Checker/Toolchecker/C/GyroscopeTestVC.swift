//
//  GyroscopeTestVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 09/01/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//

import UIKit
import CoreMotion

enum gyroscopeCell {
    case acceleratorHeader
    case gyroHeader
    case acceleratorDetails
    case gyroDetails
}

class GyroscopeTestVC: UIViewController, PopupDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var array: [gyroscopeCell] = []
    var currentMaxRotX: Double = 0.0
    var currentMaxRotY: Double = 0.0
    var currentMaxRotZ: Double = 0.0
    var motionManager: CMMotionManager!
    var yaw: Double = 0.0
    var pitch: Double = 0.0
    var roll: Double = 0.0
    var xRot: Double = 0.0
    var yRot: Double = 0.0
    var zRot: Double = 0.0
    
    class func newInstance() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "GyroscopeTestVC") as? GyroscopeTestVC else {
            return UIViewController()
        }
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.motionManager = CMMotionManager()
        self.array = [.acceleratorHeader,.acceleratorDetails,.gyroHeader,.gyroDetails]
        self.getGyroValues()
        self.getAcceleratorValues()
        self.tableView.reloadData()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getGyroValues() {
        if motionManager.isGyroAvailable {
            
            if let vc = PopUpVC.newInstance(state: .success, source: .gyroscope, next: .shakeGesture) as? PopUpVC {
                vc.delegate = self
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion:  nil)
            }
            
            motionManager.deviceMotionUpdateInterval = 0.2;
            motionManager.startDeviceMotionUpdates()
            
            motionManager.gyroUpdateInterval = 0.2
            guard let currentQueue = OperationQueue.current else { return }
            motionManager.startGyroUpdates(to: currentQueue) { (gyroData, error) in
                
                if let rotation = gyroData?.rotationRate {
                    self.xRot = rotation.x
                    self.yRot = rotation.y
                    self.zRot = rotation.z
                }
                self.tableView.reloadData()
            }
        } else {
            if let vc = PopUpVC.newInstance(state: .failed, source: .gyroscope, next: .shakeGesture) as? PopUpVC {
                vc.delegate = self
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion:  nil)
            }
        }
    }
    
    func getAcceleratorValues() {
        var attitude = CMAttitude()
        guard let motion1 = motionManager.deviceMotion else {return}
        attitude = motion1.attitude
        self.yaw = attitude.yaw
        self.pitch = attitude.pitch
        self.roll = attitude.roll
        self.tableView.reloadData()
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

extension GyroscopeTestVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.array[indexPath.row] {
        case .acceleratorHeader:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GyroscopeHeaderCell") as? GyroscopeHeaderCell else {return UITableViewCell()}
            cell.setupCell(name: "Accelerometer")
            return cell
        case .gyroHeader:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GyroscopeHeaderCell") as? GyroscopeHeaderCell else {return UITableViewCell()}
            cell.setupCell(name: "Gyroscope")
            return cell
        case .acceleratorDetails:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GyroscopeDetailsCell") as? GyroscopeDetailsCell else {return UITableViewCell()}
            cell.setupCell(a: "Acceleration in X: \(self.yaw)", b: "Acceleration in Y: \(self.pitch)", c: "Acceleration in Z: \(self.roll)")
            return cell
        case .gyroDetails:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GyroscopeDetailsCell") as? GyroscopeDetailsCell else {return UITableViewCell()}
            cell.setupCell(a: "Rotation X: \(self.yaw)", b: "Rotation Y: \(self.pitch)", c: "Rotation Z: \(self.roll)")
            return cell
        }
    }
    
    func popupNextTest(check nextTestInQueue: testNames) {
        Tests.allTests(key: nextTestInQueue, this: self.navigationController, runAllTests: true)
    }
}
