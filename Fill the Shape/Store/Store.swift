//
//  Store.swift
//  Fill the Shape
//
//  Created by Tyler Angert on 4/8/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import ReSwift

// Define the app state
struct AppState: StateType {
    
    // Game setup
    var isCurrentlyPlaying: Bool = false
    var currentDifficulty: difficultySetting = .medium
    
    // Current game stats
    var livesLeft: Int = 3
    var currentSpeed: TimeInterval = 1 // time in seconds it takes for a shape to fill and then animate back
    var currentAccuracy: Double = 1.0
    var reactionTime: TimeInterval = 0 // time in seconds it takes to tap the screen
    
    // Hook up to Realm / DB
    var highScore: Int = 0
    var currentScore: Int = 0
    
}

// Define the app reducer
func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState()
}

// Finally, define the store
var mainStore = Store<AppState>(reducer: appReducer, state: nil)
