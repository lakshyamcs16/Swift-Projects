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
    
    
    @IBOutlet weak var backButtonPressed: UIButton!
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
        guard let icon = UIImage(named: self.viewModel.imagesArray[indexPath.row]) else {
            return UITableViewCell()
        }
        switch self.viewModel.array[indexPath.row] {
        case .simCard:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Sim Card", icon: icon)
            return cell
        case .wifi:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Wifi", icon: icon)
            return cell
        case .display:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Display", icon: icon)
            return cell
        case .rearCamera:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Rear Camera", icon: icon)
            return cell
        case .frontCamera:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Front Camera", icon: icon)
            return cell
        case .vibration:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Vibration", icon: icon)
            return cell
        case .touchScreen:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Touch Screen", icon: icon)
            return cell
        case .earpiece:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Earpiece", icon: icon)
            return cell
        case .speaker:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Speaker", icon: icon)
            return cell
        case .microphone:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Microphone", icon: icon)
            return cell
        case .headphones:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Headphones", icon: icon)
            return cell
        case .charging:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Charging", icon: icon)
            return cell
        case .flash:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Flash", icon: icon)
            return cell
        case .motionSensor:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Motion Sensor", icon: icon)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        switch self.viewModel.array[indexPath.row] {
        case .simCard:
            let vc = BatteryCheckVC.newInstance(sourceTest: .simCard)
            self.navigationController?.pushViewController(vc, animated: true)
        case .wifi:
            let vc = BatteryCheckVC.newInstance(sourceTest: .wifi)
            self.navigationController?.pushViewController(vc, animated: true)
        case .display:
            let vc = BatteryCheckVC.newInstance(sourceTest: .display)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .rearCamera:
            let vc = BatteryCheckVC.newInstance(sourceTest: .rearCamera)
            self.navigationController?.pushViewController(vc, animated: true)
        case .frontCamera:
            let vc = BatteryCheckVC.newInstance(sourceTest: .frontCamera)
            self.navigationController?.pushViewController(vc, animated: true)
        case .vibration:
            let vc = BatteryCheckVC.newInstance(sourceTest: .vibration)
            self.navigationController?.pushViewController(vc, animated: true)
        case .touchScreen:
            let vc = BatteryCheckVC.newInstance(sourceTest: .touchScreen)
            self.navigationController?.pushViewController(vc, animated: true)
        case .earpiece:
            break
        case .speaker:
            break
        case .microphone:
            break
        case .headphones:
            let vc = BatteryCheckVC.newInstance(sourceTest: .headphones)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .charging:
            let vc = BatteryCheckVC.newInstance(sourceTest: .charging)
            self.navigationController?.pushViewController(vc, animated: true)
        case .flash:
            let vc = BatteryCheckVC.newInstance(sourceTest: .flash)
            self.navigationController?.pushViewController(vc, animated: true)
        case .motionSensor:
            let vc = BatteryCheckVC.newInstance(sourceTest: .motionSensor)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
