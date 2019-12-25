//
//  SingleTestListVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 25/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit

class SingleTestListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: SingleTestListVM!
    var imagesArray = ["sim", "carrier", "wifi", "display", "rear", "front", "vibrate", "touch", "earpiece", "speaker", "microphone", "headphones"]
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
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 80
        //self.tableView.rowHeight = UITableView.automaticDimension
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
extension SingleTestListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let icon = UIImage(named: imagesArray[indexPath.row]) else {
            return UITableViewCell()
        }
        switch self.viewModel.array[indexPath.row] {
        case .simCard:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Sim Card", icon: icon)
            return cell
        case .mobileCarrier:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTestCell", for: indexPath) as? SingleTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Mobile Carrier", icon: icon)
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
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.viewModel.array[indexPath.row] {
        case .simCard:
            break
        case .mobileCarrier:
            break
        case .wifi:
            break
        case .display:
            break
        case .rearCamera:
            break
        case .frontCamera:
            break
        case .vibration:
            break
        case .touchScreen:
            break
        case .earpiece:
            break
        case .speaker:
            break
        case .microphone:
            break
        case .headphones:
            break
        }
    }
}
