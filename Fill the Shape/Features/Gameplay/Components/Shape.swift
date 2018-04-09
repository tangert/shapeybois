//
//  Shape.swift
//  Fill the Shape
//
//  Created by Tyler Angert on 4/8/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import Foundation
import SpriteKit

// Define the types of shapes
enum ShapeType: Int {
    case circle = 0
    case triangle = 1
    case square = 2
    case pentagon = 3
}

// Defines whether the shape is an inner/outer shape for gameplay
enum ShapePurpose {
    case inner // the shape that gradually animates to fill in/out
    case outer // serves as the boundry
}

// Define the shape model used for the actual SKNode
struct ShapeModel {
    var type: ShapeType = .circle
    var sides: Int {
        switch(self.type){
        case .circle:
            return 0
        case .triangle:
            return 3
        case .square:
            return 4
        case .pentagon:
            return 5
        }
    }
}

// Shape node used in Gameplay
// Used as the base for inner shape and the border shape
class Shape: SKShapeNode {
    
    // Holds basic shape information about the node
    var model: ShapeModel!
    
    // Defines whether the node will be a boundary (outer) or an animated (inner) node
    var purpose: ShapePurpose!
    
    init(type: ShapeType, purpose: ShapePurpose){
        super.init()
        self.model = ShapeModel.init(type: type)
        self.purpose = purpose
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
