//
//  Store.swift
//  Fill the Shape
//
//  Created by Tyler Angert on 4/8/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import ReSwift
import SpriteKit

// Define the app state
struct AppState: StateType {
    
    // Game setup
    var gameplayState: GameplayState = .notStarted
    var currentDifficulty: difficultySetting = .medium
    
    // Current game stats
    var highScore: Int = 0
    var livesLeft: Int = 3
    var currentShape: ShapeType = .circle // cycles between the different shape types
    var currentAccuracy: Double = 1.0
    var currentScore: Int = 0
    var currentColor: SKColor = SKColor.black
    var totalRounds: Int = 0
    
    // Time variables
    var timeLeft: TimeInterval = 5 // time in seconds left for the user to tap the screen
    var currentSpeed: TimeInterval = 0.3 // time in seconds it takes for a shape to fill and then animate back
    var reactionTime: TimeInterval = 0 // time in seconds it takes to tap the screen
    
}

// Define the app reducer
//func combineReducers(_ reducers: [Reducer]) -> Reducer {
//    return {
//        action, state in
//        for reducer in reducers {
//            reducer(action)
//        }
//    }
//}

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState()
}

// Finally, define the store
var mainStore = Store<AppState>(reducer: gameplayReducer, state: nil)
