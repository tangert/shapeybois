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

struct adjustGameplayState: Action {
    var type = "ADJUST_GAMEPLAY_STATE"
    var payload: [String : AnyObject]?
    
    init(payload: [String : AnyObject]?) {
        self.payload = payload
    }
    
    init(){
        self.payload = [:]
    }
}

struct tapScreen: Action {
    var type = "TAP_SCREEN"
    var payload: [String : AnyObject]?
    
    init(payload: [String : AnyObject]?) {
        self.payload = payload
    }
    
    init(){
        self.payload = [:]
    }
}

struct increaseSpeed: Action {
    var type = "INCREASE_SPEED"
    var payload: [String : AnyObject]?
    
    init(payload: [String : AnyObject]?) {
        self.payload = payload
    }
    
    init(){
        self.payload = [:]
    }
}

struct setNewHighScore: Action {
    var type = "SET_NEW_HIGHSCORE"
    var payload: [String : AnyObject]?
    
    init(payload: [String : AnyObject]?) {
        self.payload = payload
    }
    
    init(){
        self.payload = [:]
    }
}

struct decreaseLivesLeft: Action {
    var type = "DECREASE_LIVES_LEFT"
    var payload: [String : AnyObject]?
    
    init(payload: [String : AnyObject]?) {
        self.payload = payload
    }
    
    init(){
        self.payload = [:]
    }
}

struct setCurrentColor: Action {
    var type = "SET_CURRENT_COLOR"
    var payload: [String : AnyObject]?
    
    init(payload: [String : AnyObject]?) {
        self.payload = payload
    }
    
    init(){
        self.payload = [:]
    }
}

struct setCurrentShape: Action {
    var type = "SET_CURRENT_SHAPE"
    var payload: [String : AnyObject]?
    
    init(payload: [String : AnyObject]?) {
        self.payload = payload
    }
    
    init(){
        self.payload = [:]
    }
}

struct setCurrentAccuracy: Action {
    var type = "SET_CURRENT_ACCURACY"
    var payload: [String : AnyObject]?
    
    init(payload: [String : AnyObject]?) {
        self.payload = payload
    }
    
    init(){
        self.payload = [:]
    }
}

struct increaseScore: Action {
    var type = "INCREASE_SCORE"
    var payload: [String : AnyObject]?
    
    init(payload: [String : AnyObject]?) {
        self.payload = payload
    }
    
    init(){
        self.payload = [:]
    }
}

struct increaseRounds: Action {
    var type = "INCREASE_ROUNDS"
    var payload: [String : AnyObject]?
    
    init(payload: [String : AnyObject]?) {
        self.payload = payload
    }
    
    init(){
        self.payload = [:]
    }
}

struct setLastAction: Action {
    var type = "SET_LAST_ACTION"
    var payload: [String : AnyObject]?
    
    init(payload: [String : AnyObject]?) {
        self.payload = payload
    }
    
    init(){
        self.payload = [:]
    }
}
