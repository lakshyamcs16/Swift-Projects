//
//  GameActions.swift
//  Shapify
//
//  Created by Aashna Narula on 20.03.18.
//  Copyright © 2018 aashnanarula. All rights reserved.
//

import Foundation

protocol GameActions {
    
    var deck: [String] { get }
    var rightFigureName: String? { get }
    
    func userChoose(index: Int)
    
    func setupLogic(delegate: GameEvents, deckSize: Int)
    
}

