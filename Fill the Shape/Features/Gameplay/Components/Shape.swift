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
    case triangle = 3
    case square = 4
    case pentagon = 5
    
    static func random() -> ShapeType {
        let max = ShapeType.pentagon.rawValue + 1
        var rand = Int(arc4random_uniform(UInt32(max)))
        if rand == 1 { rand = 0 }
        if rand == 2 { rand = 3 }
        return self.init(rawValue: rand)!
    }
}

// Defines whether the shape is an inner/outer shape for gameplay
enum ShapePurpose {
    case inner // the shape that gradually animates to fill in/out
    case outer // serves as the boundry
}

// Define the shape model used for the actual SKNode
struct ShapeModel {
    var type: ShapeType = .circle
    var purpose: ShapePurpose? = nil
    var sides: Int {
        return self.type.rawValue
    }
}

// Shape node used in Gameplay
// Used as the base for inner shape and the border shape
class Shape: SKShapeNode {
    
    // Holds basic shape information about the node
    var parentRect: CGRect!
    var testRect: CGRect!
    var model: ShapeModel!
    var width: CGFloat!
    var color: SKColor!
    var rotationOffset = CGFloat(.pi / 2.0)
    
    init(type: ShapeType, purpose: ShapePurpose, parentRect: CGRect, position: CGPoint, width: CGFloat) {
        super.init()
        
        // Initialize variables
        self.model = ShapeModel.init(type: type, purpose: purpose)
        self.parentRect = parentRect
        self.position = position
        self.width = width
        
        // Set the color
        setColor()
        
        // Create the path
        createInitialShape()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createInitialShape() {
        
        let newPath = createPolygonPath(parentRect: parentRect, lineWidth: 2, type: .circle, cornerRadius: 0, rotationOffset: rotationOffset)
        self.path = newPath.cgPath
        print("Initial position: \(self.position)")
        
    }
    
    // MARK: Settters
    
    func setColor(color: SKColor = .random) {
        if self.model.purpose == .inner {
            self.fillColor = color
        } else {
            self.strokeColor = color
        }
    }
    
    func setNewShape(type: ShapeType) {
        
        let newPath = createPolygonPath(parentRect: parentRect, lineWidth: 2, type: type, cornerRadius: 0, rotationOffset: rotationOffset)
        self.path = newPath.cgPath
        
        bounceAnimate()
        setColor()

        print("New position: \(self.position)")
    }
    
    func bounceAnimate() {
        self.setScale(0.5)
        let popAction = SKAction.scale(to: 1, duration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1)
        self.run(popAction)
    }
    
    // Shape path functions
    func createPolygonPath(parentRect: CGRect,
                           lineWidth: CGFloat,
                           type: ShapeType,
                           cornerRadius: CGFloat,
                           rotationOffset: CGFloat = 0)
        -> UIBezierPath {
            
            // Grab the center
            let center = self.position
            
            // Circular path
            if type == .circle {
                
                let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(self.width/2), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                
                return circlePath
            }
            
            // All other paths
            let sides = type.rawValue
            let path = UIBezierPath()
            let theta: CGFloat = CGFloat(2.0 * .pi) / CGFloat(sides)
            let width = self.width/2
            
            let first = width - lineWidth + cornerRadius
            let second = (cos(theta) * cornerRadius) / 2.0
            let radius = first - second
            
            var angle = CGFloat(rotationOffset)
            let corner = CGPoint(x: center.x+(radius-cornerRadius)*cos(angle), y: center.y+(radius-cornerRadius)*sin(angle))
            
            path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
            
            for _ in 0 ..< sides {
                angle += theta
                let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
                
                let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
                
                let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
                
                let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
                
                path.addLine(to: start)
                path.addQuadCurve(to: end, controlPoint: tip)
            }
            
            path.close()
            
            return path
    }

    
}
