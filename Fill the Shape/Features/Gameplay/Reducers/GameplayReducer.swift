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
        
        case let ags as ADJUST_GAMEPLAY_STATE:
            state.gameplayState = ags.state
        
        case let ts as TAP_SCREEN:
            state.currentAccuracy = ts.accuracy
        
        case _ as DECREASE_TIMER:
            state.timeLeft = state.timeLeft - 1
        
        case let snhs as SET_NEW_HIGHSCORE:
            state.highScore = snhs.newScore
        
        case _ as DECREASE_LIVES_LEFT:
            state.livesLeft = state.livesLeft - 1
        
        case let scs as SET_CURRENT_SHAPE:
            state.currentShape = scs.shape
        
        case let sca as SET_CURRENT_ACCURACY:
            state.currentAccuracy = sca.accuracy
        
        case let scs as SET_CURRENT_SCORE:
            state.currentScore = scs.score
        
        default:
            break
    }
    
    return state
}
