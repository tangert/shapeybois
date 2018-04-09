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
    case let t as TAP_SCREEN:
        state.currentAccuracy = t.accuracy
    default:
        break
    }
    
    return state
}
