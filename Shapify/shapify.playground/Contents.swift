/*:
 In this playground, you will configure the game **Let's Shapify**. There are 120 levels in total.
 
 The goal of the game **Let's Shapify** is to observe and categorise shapes based on their appearance and color.
 
 */
/*:
 # Game
 The following are the **rules** for the game.
 You have to match the shape occuring on the upper right side of the playground with all the shapes occuring in the deck.
 
 Let's get you familiar with some **Shapes** that you are going to see on your playground.
 
 ![1](1_1.png)
 ![2](1_2.png)
 ![3](1_3.png)
 
 ## Levels
 * Level 1 - Level 15:  Time - 7 Seconds
 * Round 16 - Level 35 :  Time - 10 Seconds
 * Round 36 - Level 45 :  Time - 12 Seconds
 * Round 46 - Level 65 :  Time - 15 Seconds
 * Round 66 - Level 85 :  Time - 17 Seconds
 * Round 86 - Level 105 :  Time - 20 Seconds
 * Round 106 - Level 120 :  Time - 25 Seconds
 
 **Explore the game at your own pace and see if you can conquer all the levels.**
 */

import PlaygroundSupport
import SpriteKit
import Foundation



let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
let scene = FirstScene(size: CGSize(width: 640, height: 480))
scene.scaleMode = .aspectFill

// Present the scene
sceneView.presentScene(scene)


PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

