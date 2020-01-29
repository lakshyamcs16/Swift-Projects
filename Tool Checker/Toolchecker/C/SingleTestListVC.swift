//
//  SingleTestListVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 25/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit

class SingleTestListVC: UIViewController {

    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: SingleTestListVM!
    class func newInstance() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SingleTestListVC") as? SingleTestListVC else {
            return UIViewController()
        }
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SingleTestListVM()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension SingleTestListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.array[indexPath.row] {
        case .simCard:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Sim Card", icon: "sim")
            return cell
        case .wifi:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Wifi", icon: "wifi")
            return cell
        case .display:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Display", icon: "display")
            return cell
        case .rearCamera:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Rear Camera", icon: "rear")
            return cell
        case .frontCamera:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Front Camera", icon: "front")
            return cell
        case .vibration:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Vibration", icon: "vibrate")
            return cell
        case .touchScreen:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Touch Screen", icon: "touch")
            return cell
        case .speaker:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Speaker", icon: "speaker")
            return cell
        case .microphone:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Microphone", icon: "microphone")
            return cell
        case .headphones:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Headphones", icon: "headphone")
            return cell
        case .charging:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Charging", icon: "battery")
            return cell
        case .flash:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Flash", icon: "flash")
            return cell
        case .shakeGesture:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Shake Gesture", icon: "shake")
            return cell
        case .gyroscope:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Gyroscope", icon: "gyroscope")
            return cell
        case .proximitySensor:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Proximity Sensor", icon: "proximity")
            return cell
        case .buttons:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Buttons", icon: "button")
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        Tests.allTests(key: self.viewModel.array[indexPath.row], this: (self.navigationController)!, runAllTests: false)
    }
}
