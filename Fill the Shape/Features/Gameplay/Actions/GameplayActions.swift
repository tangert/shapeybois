//
//  Actions.swift
//  Fill the Shape
//
//  Created by Tyler Angert on 4/8/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import ReSwift
import SpriteKit

// MARK: Gameplay setup
struct ADJUST_GAMEPLAY_STATE: Action {
    let state: GameplayState
}

// MARK: User actions
// When the user taps the screen
struct TAP_SCREEN: Action {
    let accuracy: Double
}

// MARK: Gameplay variable actions
struct DECREASE_TIMER: Action {}
struct INCREASE_SPEED: Action {
    let amount: TimeInterval
}

struct SET_NEW_HIGHSCORE: Action {
    let newScore: Int
}
struct DECREASE_LIVES_LEFT: Action {}
struct SET_CURRENT_COLOR: Action {
    let color: SKColor
}
struct SET_CURRENT_SHAPE: Action {
    let shape: ShapeType
}
struct SET_CURRENT_ACCURACY: Action {
    let accuracy: Double
}
struct INCREASE_SCORE: Action {}
struct INCREASE_ROUNDS: Action {}

