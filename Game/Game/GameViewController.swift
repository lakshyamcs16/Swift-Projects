//
//  GameViewController.swift
//  Game
//
//  Created by Aashna Narula on 03/02/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var SKViewSize: CGSize?
var SKViewSizeRect: CGRect?

class GameViewController: UIViewController {
    
    func presentView() {
        let transition = SKTransition.crossFade(withDuration: 0)

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "FirstScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
            
            //view.ignoresSiblingOrder = true
            //view.showsFields = true
            //view.sizeToFit()
            //view.showsPhysics = true
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presentView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
