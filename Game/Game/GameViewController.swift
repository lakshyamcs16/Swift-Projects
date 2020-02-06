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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "FirstScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFields = true
            view.sizeToFit()
            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        SKViewSize = self.view.bounds.size
        SKViewSizeRect = getViewSizeRect()

        let skView = self.view as! SKView
        if let scene = skView.scene {
            if scene.size != self.view.bounds.size {
                scene.size = self.view.bounds.size
            }
        }
    }
    
    func getViewSizeRect() -> CGRect {
        return CGRect(x: ((SKViewSize!.width  * 0.5) * -1.0), y: ((SKViewSize!.height * 0.5) * -1.0), width: SKViewSize!.width, height: SKViewSize!.height)
    }
    
    override var shouldAutorotate: Bool {
        return true
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

public extension SKNode {
    func posByScreen(x: CGFloat, y: CGFloat) {
        self.position = CGPoint(x: CGFloat((SKViewSizeRect!.width * x) + SKViewSizeRect!.origin.x), y: CGFloat((SKViewSizeRect!.height * y) + SKViewSizeRect!.origin.y))
    }
}
