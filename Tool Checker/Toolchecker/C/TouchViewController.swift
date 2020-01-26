//
//  TouchViewController.swift
//  Toolchecker
//
//  Created by Aashna Narula on 27/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit

class TouchViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    private var timer: Timer?
    private let pollingDuration: Int = 1
    private var pollingCount : Int = 20
    private var maxPollingCount : Int = 1
    private var runAll: Bool = false
    @IBOutlet weak var gView: GridView!
    
    class func newInstance(runAllTests: Bool) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "touchVC") as? TouchViewController else {
            return UIViewController()
        }
        vc.runAll = runAllTests
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gView.runAllTest = self.runAll
        view.backgroundColor = UIColor.white
        timerLabel.layer.cornerRadius = timerLabel.frame.width / 2
        timerLabel.backgroundColor = UIColor.lightGray
        timerLabel.textColor = UIColor.black
        timerLabel.layer.masksToBounds = true
        timerLabel.layer.zPosition = CGFloat(UInt64.max)
        self.startTimer()
    }
    
    func goToTestView(numOfScreensToPop: Int) {
        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - numOfScreensToPop]
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    
    private func startTimer() {
        self.stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.showAlert), userInfo: nil, repeats: true)
        self.gView.timer = timer
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    @objc func showAlert() {
        if pollingCount >= maxPollingCount {
            self.timerLabel.text = String(pollingCount)
            pollingCount = pollingCount - 1
        } else {
            self.stopTimer()
            let alert = UIAlertController(title: "Touch Check", message: "Time's up. Want to continue?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.pollingCount = 20
                self.startTimer()
            }
            let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                UIAlertAction in
//                self.dismiss(animated: true, completion: nil)
                if self.runAll {
                    Tests.allTests(key: .speaker, this: self.navigationController, runAllTests: true)
                }else {
                    self.goToTestView(numOfScreensToPop: 2)
                }
            }
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
