//
//  HelpButton.swift
//  Game
//
//  Created by Aashna Narula on 10/02/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//

import SpriteKit


// MARK: Play Button Delegate

protocol HelpButtonDelegate: class {
    func didTapHelp(sender: HelpButton)
}

public class HelpButton: SKSpriteNode {
    
    weak var delegate: HelpButtonDelegate?
    
    init() {
        let texture = SKTexture(imageNamed: "help")
        
        let color = SKColor.red
        let size = CGSize(width: 220, height: 56)
        super.init(texture: texture, color: color, size: size)
        
        isUserInteractionEnabled = true
        zPosition = 1
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Touch Handling
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        alpha = 0.5
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let alphaAction = SKAction.fadeAlpha(to: 0.5, duration: 0.10)
        alphaAction.timingMode = .easeInEaseOut
        run(alphaAction)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        performButtonAppearanceResetAnimation()
        delegate?.didTapHelp(sender: self)
        
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        performButtonAppearanceResetAnimation()
    }
    
    // MARK: Helper Functions
    
    func performButtonAppearanceResetAnimation() {
        let alphaAction = SKAction.fadeAlpha(to: 1.0, duration: 0.10)
        alphaAction.timingMode = .easeInEaseOut
        run(alphaAction)
    }
    
}




