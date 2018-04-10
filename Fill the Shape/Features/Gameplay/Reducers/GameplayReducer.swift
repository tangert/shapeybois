//
//  GameplayReducer.swift
//  Fill the Shape
//
//  Created by Tyler Angert on 4/8/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import ReSwift
import SpriteKit

func gameplayReducer(action: Action, state: AppState?) -> AppState {
    
    var state = state ?? AppState()
    
    switch action {
        
    case let a as adjustGameplayState:
        state.gameplayState = a.payload!["state"] as! GameplayState
        state.lastAction = a.type
    
    case let a as increaseSpeed:
        state.currentSpeed -= a.payload!["amount"] as! TimeInterval
        state.lastAction = a.type

    case let a as tapScreen:
        state.currentAccuracy = a.payload!["accuracy"] as! Double
        state.lastAction = a.type

    case let a as setNewHighScore:
        state.highScore = a.payload!["newScore"] as! Int
        state.lastAction = a.type
    
    case let a as decreaseLivesLeft:
        state.livesLeft -= 1
        state.lastAction = a.type
    
    case let a as setCurrentShape:
        state.currentShape = a.payload!["type"] as! ShapeType
        state.lastAction = a.type
    
    case let a as setCurrentColor:
        state.currentColor = a.payload!["color"] as! SKColor
        state.lastAction = a.type
    
    case let a as setCurrentAccuracy:
        state.currentAccuracy = a.payload!["accuracy"] as! Double
        state.lastAction = a.type

    case let a as tapSuccessful:
        state.lastTapSuccessful = true
        state.lastAction = a.type
    
    case let a as tapFailure:
        state.lastTapSuccessful = false
        state.lastAction = a.type
    
    case let a as increaseScore:
        state.currentScore += 1
        state.lastAction = a.type
    
    case let a as increaseRounds:
        state.totalRounds += 1
        state.lastAction = a.type
        
    default:
        return state
    }
    
    return state
}
