//
//  Actions.swift
//  Fill the Shape
//
//  Created by Tyler Angert on 4/8/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import ReSwift

// MARK: Gameplay setup
struct START_GAME: Action {}
struct PAUSE_GAME: Action {}
struct END_GAME: Action {}

// MARK: User actions
// When the user taps the screen
struct TAP_SCREEN: Action {
let accuracy: Double
}

// MARK: Gameplay variable actions
struct DECREASE_TIMER: Action {}
struct SET_NEW_HIGHSCORE: Action {
    let newScore: Int
}
struct DECREASE_LIVES_LEFT: Action {}
struct SET_CURRENT_SHAPE: Action {
    let shape: ShapeType
}
struct SET_CURRENT_ACCURACY: Action {}
struct SET_CURRENT_SCORE: Action {}

