//
//  DisplayCheckViewController.swift
//  Toolchecker
//
//  Created by Aashna Narula on 27/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit

protocol DisplayCheckVCDelegate {
    func DisplayCheckControllerResponse(check hasCheckCompleted: Bool)
}

class DisplayCheckViewController: UIViewController {

    let colors: [UIColor] = [ .white, .red, .green, .black ]
    var colorIndex: Int = -1
    var delegate: DisplayCheckVCDelegate?
    
    class func newInstance() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "displayCheckVC") as? DisplayCheckViewController else {
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
        view.backgroundColor = UIColor.blue
        setupTap()
    }
}

extension DisplayCheckViewController {
    func setupTap() {
        let touchDown = UITapGestureRecognizer(target: self, action: #selector(didTouchDown))
        view.addGestureRecognizer(touchDown)
    }
    
    func goToTestView() {
        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    @objc func didTouchDown(sender: UITapGestureRecognizer? = nil) {
        
        colorIndex = colorIndex + 1
        if colorIndex < colors.count {
            view.backgroundColor = colors[colorIndex]
        } else {
            navigationController?.popViewController(animated: true)
            self.delegate?.DisplayCheckControllerResponse(check: true)
        }
    }
}
