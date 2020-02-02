//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import Foundation
import GameKit

class TouchableSrpiteNode : SKSpriteNode
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.25)
        fadeOutAction.timingMode = .easeInEaseOut
        
        self.run(fadeOutAction, completion: {
            
            self.removeFromParent()
        })
        
    }
}


class FirstScene: SKScene {
    
    private var label : SKLabelNode!
    
    let allFig: [String] = ["1_1.png","1_3.png","1_2.png"]

    let wwdcIconName = "wwdcIcon"
    let buttonNodeName = "button"
//    var rightFigureNode: SKSpriteNode!
    var lineWiseX : CGFloat = 0
    var lineWiseY : CGFloat = 0
    var jumpedAhead = false
    let emojis = ["😀","😃","😄","😁","😆","😅","😂","🤣","☺️","😊","😇","🙂","🙃","😉","😌","😍","😘","😗","😛","😝","😜","😋","😚","😙","🤑","🤗","🤓","😎","🤡","🤠","😏","😒","😞","😣","☹️","🙁","😖","😔","😫","😟","😕","😩","😳","😈","👻","💀","👽","😻","😺","🎃","🙈","🐵","🙉","⚡️","🔥","💥","👱‍♀️","👱","🤦‍♀️","🤦‍♂️","🐣","🐥","☃️","🎊","🎁","🎉","🎎","💃🏻","🕺"]
    
    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        
        
        let background = SKSpriteNode(imageNamed: "images.png")
        background.name = "background"
        background.setScale(2.8)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        let playButton = SKSpriteNode(imageNamed: "play")
        playButton.size = CGSize(width: 120, height: 60)
        playButton.position = CGPoint(x: self.frame.midX, y: 200)
        playButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: playButton.frame.width * 1.25 , height: playButton.frame.height * 2.5))
        playButton.physicsBody?.isDynamic = false
        playButton.alpha = 1
        playButton.name = "play"
        playButton.zPosition = 3
        addChild(playButton)
        
        addLinewiseEmojiElements()
        
    }
    
    func addLinewiseEmojiElements()
    {
        print(self.frame.height, self.frame.width)
        physicsWorld.gravity = CGVector.init(dx: 0, dy: 0)
        //        self.lineWiseX = -self.frame.width/2
        //        self.lineWiseY = -self.frame.height/2
        let wait = SKAction.wait(forDuration:0.02)
        let action = SKAction.run {
            let point = CGPoint(x: self.lineWiseX, y: self.lineWiseY)
            self.createRandomEmoji(at: point)
            self.lineWiseX = self.lineWiseX + 30
            
            if(self.lineWiseX >= self.frame.width + 50)
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
    
    
    func createRandomEmoji(at point: CGPoint) {
        let randomEmojiIndex = GKRandomSource.sharedRandom().nextInt(upperBound: allFig.count)
        
        let person = SKSpriteNode()
        person.texture = SKTexture(imageNamed: allFig[randomEmojiIndex])
        person.name = "textureFig"
        person.size = CGSize(width:40, height: 40)
        person.position = CGPoint(x: point.x, y: point.y)
        
        let maxRadius = max(person.frame.size.width/2, person.frame.size.height/2)
        let interPersonSeparationConstant: CGFloat = 1.25
        person.physicsBody = SKPhysicsBody(circleOfRadius: maxRadius*interPersonSeparationConstant)
        
        addChild(person)
    }
    
    
//    func createRandomEmoji(at point: CGPoint) {
//        //        print("Added", point)
//
//        let randomEmojiIndex = GKRandomSource.sharedRandom().nextInt(upperBound: allFig.count)
//
//        let name = allFig[randomEmojiIndex]
//        print(name)
//        rightFigureNode.texture = SKTexture(imageNamed: name)
//        rightFigureNode.zPosition = 2
//
//
//        rightFigureNode.position = CGPoint(x: point.x, y: point.y)
//
//        let maxRadius = max((rightFigureNode.frame.size.width)/2, (rightFigureNode.frame.size.height)/2)
//        let interPersonSeparationConstant: CGFloat = 1.25
//        rightFigureNode.physicsBody = SKPhysicsBody(circleOfRadius: maxRadius*interPersonSeparationConstant)
//
//        addChild(rightFigureNode)
//    }

    override public func didSimulatePhysics() {
        super.didSimulatePhysics()

        // Remove nodes if they're outside the view
        enumerateChildNodes(withName: wwdcIconName) { (node, stop) in
            if node.position.y < -50 || node.position.y > self.frame.size.height + 50 || node.position.x < -50 || node.position.x > self.frame.size.width + 50 {
                node.removeFromParent()
            }
        }
    }
    
   
    
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
let scene = FirstScene(size: CGSize(width: 640, height: 480))
scene.scaleMode = .aspectFill

// Present the scene
sceneView.presentScene(scene)


PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

