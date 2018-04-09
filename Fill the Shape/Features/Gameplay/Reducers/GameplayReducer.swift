//
//  GameplayReducer.swift
//  Fill the Shape
//
//  Created by Tyler Angert on 4/8/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import ReSwift

func gameplayReducer(action: Action, state: AppState?) -> AppState {
    
    var state = state ?? AppState()
    
    switch action {
        
        case let a as ADJUST_GAMEPLAY_STATE:
            state.gameplayState = a.state
        
        case let a as INCREASE_SPEED:
            state.currentSpeed = state.currentSpeed - a.amount
        
        case let a as TAP_SCREEN:
            state.currentAccuracy = a.accuracy
        
        case _ as DECREASE_TIMER:
            state.timeLeft = state.timeLeft - 1
        
        case let a as SET_NEW_HIGHSCORE:
            state.highScore = a.newScore
        
        case _ as DECREASE_LIVES_LEFT:
            state.livesLeft = state.livesLeft - 1
        
        case let a as SET_CURRENT_SHAPE:
            state.currentShape = a.shape
        
        case let a as SET_CURRENT_ACCURACY:
            state.currentAccuracy = a.accuracy
        
        case let a as SET_CURRENT_SCORE:
            state.currentScore = a.score
        
        default:
            return state
    }
    
    return state
}
