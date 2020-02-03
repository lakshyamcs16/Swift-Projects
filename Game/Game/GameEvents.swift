//
//  GameEvents.swift
//  Shapify
//
//  Created by Aashna Narula on 20.03.18.
//  Copyright © 2018 aashnanarula. All rights reserved.
//


import Foundation

protocol GameEvents {
    
    var level: Int { get set }
    var timer: Int {get set}
    var lives: Int { get set }
    
    func userDidRightChoice(index: Int)
    func userDidWrongChoice()
    
    func gameOver()
    func moveToNextLevel()
    func drawLives()
    
}

