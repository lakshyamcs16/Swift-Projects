//
//  GameScene.swift
//  Game
//
//  Created by Aashna Narula on 03/02/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//
//
//  FirstScene.swift
//  Shapify
//
//  Created by Aashna Narula on 20.03.18.
//  Copyright © 2018 aashnanarula. All rights reserved.
//

import SpriteKit
import Foundation
import GameKit
import GameplayKit



public class FirstScene: SKScene {
    
    private var label : SKLabelNode!
    var backgroundMusic: SKAudioNode!
    
    let allFig: [String] = ["1_1.png","1_3.png","1_2.png","4","8","12","16","20","24","28","32","36","40","44","48","52","56","60","64","68","72","76","80","84","88","92","96","100","104","108","112","116","120","124","128","132","136","140","144","148","152","156","160"]
    let buttonNodeName = "button"
    var lineWiseX : CGFloat = 0
    var lineWiseY : CGFloat = 0
    var jumpedAhead = false
    
    
    public override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "img.png")
        background.name = "background"
        background.setScale(2.8)
        addChild(background)
        
        
        let gameName = "Let's Shapify!"
        let welcome = SKLabelNode(fontNamed: "Chalkduster")
        welcome.text = gameName
        welcome.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: welcome.frame.width * 2.25 , height: welcome.frame.height * 3.5))
        welcome.physicsBody?.isDynamic = false
        welcome.fontSize = 48
        welcome.fontColor = SKColor.black
        welcome.position = CGPoint(x: self.frame.midX, y: 300)
        welcome.alpha = 1
        welcome.zPosition = 3
        addChild(welcome)
        
        
        let buttonNodeName = "button"
        let button = PlayButton()
        button.name = buttonNodeName
        button.delegate = self
        button.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        button.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: button.frame.width * 2.25 , height: button.frame.height * 3.5))
        button.physicsBody?.isDynamic = false
        button.alpha = 0
        let fadeInOut = SKAction.sequence([.fadeIn(withDuration: 0.5),
                                           .fadeOut(withDuration: 0.5)])
        button.run(.repeatForever(fadeInOut))
        addChild(button)
        
        let helpButtonNodeName = "helpButton"
        let helpButton = HelpButton()
        helpButton.name = helpButtonNodeName
        helpButton.delegate = self
        helpButton.position = CGPoint(x: self.frame.maxX - 150, y: frame.maxY - 100)
        helpButton.size = CGSize(width: 120, height: 120)
        helpButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: helpButton.frame.width * 1.5, height: helpButton.frame.height * 1.5))
        helpButton.physicsBody?.isDynamic = false
        helpButton.alpha = 1
        addChild(helpButton)
        
        
        addLinewiseShape()
    }
    
    func addLinewiseShape()
    {
        print(self.frame.height, self.frame.width)
        physicsWorld.gravity = CGVector.init(dx: 0, dy: 0)
        
        let wait = SKAction.wait(forDuration:0.02)
        let action = SKAction.run {
            let point = CGPoint(x: self.lineWiseX, y: self.lineWiseY)
            self.createShape(at: point)
            self.lineWiseX = self.lineWiseX + 30
            if(self.lineWiseX >= self.frame.width)
            {
                self.lineWiseX = 0
                self.jumpedAhead = false
                self.lineWiseY = self.lineWiseY + 30
            }
            if (self.lineWiseY >= self.frame.height)
            {
                self.removeAllActions()
                self.enumerateChildNodes(withName: self.buttonNodeName) { (node, stop) in
                    let fadeInAction = SKAction.fadeIn(withDuration: 0.25)
                    fadeInAction.timingMode = .easeInEaseOut
                    node.run(fadeInAction, completion: {
                        node.alpha = 1
                    })
                }
            }
        }
        run(SKAction.repeatForever(SKAction.sequence([wait, action])))
    }
    
    func createShape(at point: CGPoint) {
        
        let action = SKAction.playSoundFileNamed("begin.mp3", waitForCompletion: true)
        self.run(action)
        
        let randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: allFig.count)
        let shape = SKSpriteNode()
        shape.texture = SKTexture(imageNamed: allFig[randomIndex])
        shape.name = "textureFig"
        shape.size = CGSize(width:70, height: 70)
        shape.position = CGPoint(x: point.x, y: point.y)
        shape.zPosition = 10
        let maxRadius = max(shape.frame.size.width/2, shape.frame.size.height/2)
        let interPersonSeparationConstant: CGFloat = 1.25
        shape.physicsBody = SKPhysicsBody(circleOfRadius: maxRadius*interPersonSeparationConstant)
        addChild(shape)
    }
}

extension FirstScene: PlayButtonDelegate, openGame {
    func didTapPlay(sender: PlayButton) {
        openGameScene()
    }
    
    func openGameSceneProtocol() {
        openGameScene()
    }
    
    func openGameScene() {
        let action = SKAction.playSoundFileNamed("popSound.mp3", waitForCompletion: false)
        self.run(action)
        let transition = SKTransition.crossFade(withDuration: 0)
        guard let scene1 = GameScene(fileNamed:"GameScene") else {return}
        scene1.level = 1
        scene1.scaleMode = .aspectFill
        self.scene?.view?.presentScene(scene1, transition: transition)
    }
}

extension FirstScene: HelpButtonDelegate {
    func didTapHelp(sender: HelpButton) {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpViewController")
        let hvc = newViewController as? HelpViewController
        hvc?.delegate = self
        UIApplication.topViewController()?.present(newViewController, animated: false, completion: nil)
    }
}
