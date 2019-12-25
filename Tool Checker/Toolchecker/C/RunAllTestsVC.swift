//
//  ViewController.swift
//  Toolchecker
//
//  Created by Aashna Narula on 23/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit

class RunAllTestsVC: UIViewController {
    
    var viewModel: RunAllTestsVM!
    @IBOutlet weak var tableView: UITableView!
    
    class func newInstance() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "RunAllTestsVC") as? RunAllTestsVC else {
            return UIViewController()
        }
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = RunAllTestsVM()
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
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RunAllTestsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let icon = UIImage(named: self.viewModel.imagesArray[indexPath.row]) else {
            return UITableViewCell()
        }
        switch self.viewModel.array[indexPath.row] {
        case .simCard:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Sim Card", icon: icon)
            return cell
        case .mobileCarrier:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Mobile Carrier", icon: icon)
            return cell
        case .wifi:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Wifi", icon: icon)
            return cell
        case .display:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Display", icon: icon)
            return cell
        case .rearCamera:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Rear Camera", icon: icon)
            return cell
        case .frontCamera:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Front Camera", icon: icon)
            return cell
        case .vibration:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Vibration", icon: icon)
            return cell
        case .touchScreen:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Touch Screen", icon: icon)
            return cell
        case .earpiece:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Earpiece", icon: icon)
            return cell
        case .speaker:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Speaker", icon: icon)
            return cell
        case .microphone:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Microphone", icon: icon)
            return cell
        case .headphones:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Headphones", icon: icon)
            return cell
        case .charging:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Charging", icon: icon)
            return cell
        case .flash:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificTestCell", for: indexPath) as? SpecificTestCell else {return UITableViewCell()}
            cell.setupCell(name: "Flash", icon: icon)
            return cell
        case .none:
            return UITableViewCell()
        }
    }
}

