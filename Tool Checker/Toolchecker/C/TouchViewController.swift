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
    class func newInstance() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "touchVC") as? TouchViewController else {
            return UIViewController()
        }
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
        view.backgroundColor = UIColor.white
        timerLabel.layer.cornerRadius = timerLabel.frame.width / 2
        timerLabel.backgroundColor = UIColor.lightGray
        timerLabel.textColor = UIColor.black
        timerLabel.layer.masksToBounds = true
        timerLabel.layer.zPosition = CGFloat(UInt64.max)
        self.setTimer()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToTestView() {
        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    
    func setTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            guard let intLabel = Int(self.timerLabel.text!) else {
                return
            }
            self.timerLabel.text = String(intLabel - 1)
            if intLabel == 1 {
                timer.invalidate()
                self.timerLabel.text = "25"
                print("Time's up")
                let alert = UIAlertController(title: "Touch Check", message: "Time's up. Want to continue?", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.setTimer()
                    print("Passed")
                }
                let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.goToTestView()
                    print("Failed")
                }
                alert.addAction(yesAction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
