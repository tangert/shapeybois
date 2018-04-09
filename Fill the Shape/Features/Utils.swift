//
//  Utils.swift
//  Fill the Shape
//
//  Created by Tyler Angert on 4/8/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation

// Stores the difficulty setting for the current game
enum difficultySetting: Double {
    case easy = 0.6 // 60% of area filled
    case medium = 0.75 // 75% of area filled
    case hard = 0.9 // 90% of area filled
}

// Stores the current playing state of the game
enum GameplayState {
    case notStarted
    case playing
    case paused
    case ended
}
