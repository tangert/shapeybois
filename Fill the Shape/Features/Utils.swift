//
//  Utils.swift
//  Fill the Shape
//
//  Created by Tyler Angert on 4/8/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import SpriteKit

// Stores the difficulty setting for the current game
enum difficultySetting: Double {
    case easy = 0.7 // 60% of area filled
    case medium = 0.8 // 75% of area filled
    case hard = 0.9 // 90% of area filled
}

func mapDifficultyToColor(setting: difficultySetting) -> SKColor {
    switch(setting){
    case .easy:
        return SKColor.green
    case .medium:
        return SKColor.orange
    case .hard:
        return SKColor.red
    }
}

// Stores the current playing state of the game
enum GameplayState {
    case notStarted
    case playing
    case paused
    case ended
}

// Convenience extensions
extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}
