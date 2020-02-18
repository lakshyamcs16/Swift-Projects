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
    func presentView(scene: String, level: Int)
}

class HighscoreVC: UIViewController {

    var delegate: present?
    
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBAction func restartTapped(_ sender: Any) {
        self.dismiss(animated: false, completion:{
            self.delegate?.presentView(scene: "GameScene", level: 1)
        })
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        self.dismiss(animated: false, completion:{
            self.delegate?.presentView(scene: "GameScene", level: self.levels)
        })
    }
    
    @IBAction func tappedOutside(_ sender: Any) {
        self.dismiss(animated: false, completion:{
            self.delegate?.presentView(scene:"FirstScene", level: -1)
        })
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion:{
            self.delegate?.presentView(scene:"FirstScene", level: -1)
        })
        
        
    }
    var levels: Int = 0
    var highscore: Int = 0
    var currentscore: Int = 0

    @IBOutlet weak var bestscoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    class func newInstance(levels: Int, highscore: Int, currentscore: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Highscore", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "highscoreVC") as? HighscoreVC else {
            return UIViewController()
        }
        vc.levels = levels
        vc.highscore = highscore
        vc.currentscore = currentscore
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.levelLabel.text = "Level " + String(self.levels)
        self.highscoreLabel.text = String(self.currentscore)
        self.bestscoreLabel.text = String(self.highscore)
    }
    
    func setStars(stars: Int) {
        if stars <= 2 {
            star3.alpha = 0.1
        }
        if stars <= 1 {
            star2.alpha = 0.1
        }
    }
}
