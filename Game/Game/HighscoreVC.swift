//
//  HighscoreVC.swift
//  Game
//
//  Created by Aashna Narula on 10/02/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//
import SpriteKit
import GameplayKit
import UIKit

protocol present {
    func presentView()
}

class HighscoreVC: UIViewController {

    var delegate: present?
    
    @IBAction func tappedOutside(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion:{
            self.delegate?.presentView()
        })
        
        
    }
    var levels: Int = 0
    
    class func newInstance(levels: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Highscore", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "highscoreVC") as? HighscoreVC else {
            return UIViewController()
        }
        vc.levels = levels
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
