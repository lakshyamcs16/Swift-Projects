//
//  GameScene.swift
//  Shapify
//
//  Created by Aashna Narula on 20.03.18.
//  Copyright © 2018 aashnanarula. All rights reserved.
//

import SpriteKit
import UIKit

public class GameScene: SKScene {
    
    var level: Int = 1
    var timer:Int = 0
    var logic: GameActions?
    var homeNode: SKSpriteNode?
    var levelLabelNode: SKLabelNode?
    var timerLabelNode: SKLabelNode?
    var rightFigureNode: SKSpriteNode?
    var deckNodes: [SKSpriteNode] = []
    var deckNodesName: [String] = []
    var lifeNodes: [SKSpriteNode] = []
    var lives: Int = 3
    
    
    public override func didMove(to view: SKView) {
        let action = SKAction.playSoundFileNamed("nextLevel.mp3", waitForCompletion: false)
        self.run(action)
        // connect nodes with scene
        self.levelLabelNode = childNode(withName: "level") as? SKLabelNode
        self.timerLabelNode = childNode(withName: "timer") as? SKLabelNode
        self.rightFigureNode = childNode(withName: "rightFigure") as? SKSpriteNode
        self.homeNode = childNode(withName: "home") as? SKSpriteNode
        
        enumerateChildNodes(withName: "//*") {
            node, stop in
            if node.name == "figure" {
                self.deckNodes.append(node as! SKSpriteNode)
                self.deckNodesName.append("")
            }
            if node.name == "life" {
                self.lifeNodes.append(node as! SKSpriteNode)
            }
        }
        // configure the label
        self.levelLabelNode?.text = "Level: \(level)"
        self.timerLabelNode?.text = "Time Left:"
        self.homeNode?.texture = SKTexture(imageNamed: "home")
        // configure logic
        self.logic = GameLogic()
        logic?.setupLogic(delegate: self, deckSize: deckNodes.count)
        // Draw sprites
        drawDeck()
        drawRightFigure()
        drawLives()
        setupTimer()
    }
    
}


// MARK: - Drawings
extension GameScene {
    
    func HomeButtonTapped() {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController")
        UIApplication.topViewController()?.present(newViewController, animated: false, completion: nil)
    }
    
    func drawDeck() {
        for (index, node) in deckNodes.enumerated() {
            guard let name = logic?.deck[index] else {return}
            self.deckNodesName[index] = name
            node.texture = SKTexture(imageNamed: name)
            node.xScale = 1.5
            node.yScale = 1.5
        }
    }
    
    func drawRightFigure() {
        if let name = logic?.rightFigureName {
            self.rightFigureNode?.texture = SKTexture(imageNamed: name)
        }
    }
    
    func drawLives() {
        if lives < 3 {
            for index in lives...2 {
                let node = lifeNodes[index]
                node.alpha = 0.2
            }
        }
    }
    
    //set timer for each level
    func setupTimer() {
        var timer = 0
        if (level >= 1 && level <=  15) {
            timer = 7
        } else if (level >= 16 && level <=  35) {
            timer = 10
        } else if (level >= 36 && level <=  45) {
            timer = 12
        } else if (level >= 46 && level <=  65) {
            timer = 15
        } else if (level >= 66 && level <=  85) {
            timer = 17
        } else if (level >= 86 && level <=  105) {
            timer = 20
        } else if (level >= 106 && level <=  120) {
            timer = 25
        }
        
        var flag = 0
        let runTimer = timer
        let waitTimer = SKAction.wait(forDuration: 1)
        let actionTimer = SKAction.run {
            self.timerLabelNode?.text = "Time Left: \(timer)"
            if timer == 1 {
                flag = 1
                let action = SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false)
                self.run(action)
        
                let timeUp = SKLabelNode(fontNamed: "Chalkduster")
                timeUp.text = "Time Up..Try Again 😭"
                timeUp.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: timeUp.frame.width * 1.25 , height: timeUp.frame.height * 2.5))
                timeUp.physicsBody?.isDynamic = false
                timeUp.fontSize = 24
                timeUp.fontColor = SKColor.black
                timeUp.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                self.addChild(timeUp)
                timeUp.alpha = 1
                timeUp.zPosition = 4
                var fadeOutAction = SKAction.fadeIn(withDuration: 1)
                fadeOutAction.timingMode = .easeInEaseOut
                timeUp.run(fadeOutAction, completion: {
                    timeUp.alpha = 1
                })
                
                
                let button = ResetButton()
                button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - (timeUp.frame.height + 30))
                button.delegate = self
                button.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: button.frame.width * 1.25 , height: button.frame.height * 2.5))
                button.physicsBody?.isDynamic = false
                self.addChild(button)
                button.alpha = 1
                fadeOutAction = SKAction.fadeIn(withDuration: 1.5)
                fadeOutAction.timingMode = .easeInEaseOut
                button.run(fadeOutAction, completion: {
                    button.alpha = 1
                })
                
                self.enumerateChildNodes(withName: "//*") {
                    node, stop in
                    if node.name != "timeUp" || node.name != "deck"{
                        node.alpha = 0.5
                        node.isUserInteractionEnabled = true
                    }
                }
            }
            else {
                if flag == 1 {
                    timer = 0
                }
                timer = timer - 1
            }
        }
        run(SKAction.repeat(SKAction.sequence([waitTimer, actionTimer]) , count: runTimer ))
    }
}

// MARK: - Event Delegation
extension GameScene: GameEvents {
    
    func userDidRightChoice(index: Int) {
        _ = deckNodes[index]
        let action = SKAction.playSoundFileNamed("rightFig.mp3", waitForCompletion: false)
        self.run(action)
        let name = deckNodes[index]
        let textureName = deckNodesName[index]
        name.texture = SKTexture(imageNamed: "\(textureName)S.png")
        name.xScale = 1.0
        name.yScale = 1.0
    }
    
    func userDidWrongChoice() {
        var action = SKAction.playSoundFileNamed("wrongFig.mp3", waitForCompletion: false)
        self.run(action)
        let index = lives - 1
        let lifeNode = lifeNodes[index]
        action = SKAction.fadeAlpha(to: 0.2, duration: 0.1)
        lifeNode.run(action)
        drawLives()
    }
    
}


extension GameScene {
    
    func gameOver() {
        let action = SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: true)
        self.run(action)
        
        let overMsg = SKLabelNode(fontNamed: "Chalkduster")
        overMsg.text = "You Lose 😭"
        overMsg.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: overMsg.frame.width * 1.25 , height: overMsg.frame.height * 2.5))
        overMsg.physicsBody?.isDynamic = false
        overMsg.fontSize = 24
        overMsg.fontColor = SKColor.black
        overMsg.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(overMsg)
        overMsg.alpha = 1
        overMsg.zPosition = 4
        var fadeOutAction = SKAction.fadeIn(withDuration: 1) //SKAction.fadeOut(withDuration: 1.25)
        fadeOutAction.timingMode = .easeInEaseOut
        overMsg.run(fadeOutAction, completion: {
            overMsg.alpha = 1
        self.removeAllActions()
        })
        
        self.enumerateChildNodes(withName: "//*") {
            node, stop in
            if node.name != "overMsg" || node.name != "deck"{
                node.alpha = 0.5
                node.isUserInteractionEnabled = true
            }
        }
        
        let button = ResetButton()
        button.position = CGPoint(x: frame.midX, y: frame.midY - (overMsg.frame.height + 30))
        button.delegate = self
        button.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: button.frame.width * 1.25 , height: button.frame.height * 2.5))
        button.physicsBody?.isDynamic = false
        addChild(button)
        button.alpha = 1
        fadeOutAction = SKAction.fadeIn(withDuration: 1.5)
        fadeOutAction.timingMode = .easeInEaseOut
        button.run(fadeOutAction, completion: {
            button.alpha = 1
        })
    }
    
    
    func moveToNextLevel() {
        let action =  SKAction.run {
            let action1 = SKAction.playSoundFileNamed("nextLevel.mp3", waitForCompletion: false)
            self.run(action1)
            let transition = SKTransition.crossFade(withDuration: 0)
            guard let nextLevelScene = GameScene(fileNamed:"GameScene") else {return}
            nextLevelScene.level = self.level + 1
            nextLevelScene.lives = self.lives
            nextLevelScene.scaleMode = SKSceneScaleMode.aspectFill
            self.scene?.view?.presentScene(nextLevelScene, transition: transition)
        }
        self.run(SKAction.sequence([SKAction.wait(forDuration : 0.35), action ]))
        
       
    }
}

// MARK: - Touches
extension GameScene {
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: self)
            let node = self.atPoint(position)
            if node.name == "figure" {
                guard let figure = node as? SKSpriteNode else {return}
                guard let index = deckNodes.firstIndex(of: figure) else {return}
                self.logic?.userChoose(index: index)
            }
            if node.name == "home" {
                self.HomeButtonTapped()
            }
        }
    }
}

extension GameScene: ResetButtonDelegate {
    
    func didTapReset(sender: ResetButton) {
        let action = SKAction.playSoundFileNamed("popSound.mp3", waitForCompletion: false)
        self.run(action)
        let transition = SKTransition.crossFade(withDuration: 0)
        guard let scene1 = GameScene(fileNamed:"GameScene") else {return}
        scene1.level = level
        scene1.scaleMode = SKSceneScaleMode.aspectFill
        self.scene?.view?.presentScene(scene1, transition: transition)
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
