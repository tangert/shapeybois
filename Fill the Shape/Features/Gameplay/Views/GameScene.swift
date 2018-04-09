//
//  GameScene.swift
//  Fill the Shape
//
//  Created by Tyler Angert on 4/8/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Used to notify store that a user has 
    private var screenTapRecognizer = UITapGestureRecognizer()
    private var testShape: Shape?
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var borderNode: SKShapeNode?
    private var selectedNode: SKShapeNode?
    
    var currentScale = 1.0
    var previousAccuracy: CGFloat = 0
    var count = 0
    
    override func didMove(to view: SKView) {
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.15
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w))
        self.borderNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w))
        self.selectedNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w))

        self.label = SKLabelNode.init(text: "accuracy: \(self.previousAccuracy)")
        self.label?.position = CGPoint.init(x: frame.midX, y: frame.midY+200)
        self.addChild(label!)
        
        self.testShape = Shape.init(type: .circle, purpose: .inner)
        
        // Get center of screen
        let center: CGPoint = CGPoint.init(x: frame.midX, y: frame.midY)
        
        print("Test shape object: \(self.testShape)")
        
        if let borderNode = self.borderNode {
            borderNode.lineWidth = 2.5
            borderNode.strokeColor = SKColor.red
            borderNode.position = center
            self.addChild(borderNode)
        }
        
        if let selectedNode = self.selectedNode {
            selectedNode.lineWidth = 2.5
            selectedNode.strokeColor = SKColor.green
            selectedNode.position = center
            self.addChild(selectedNode)
        }
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            spinnyNode.fillColor = SKColor.blue
            spinnyNode.run(
                SKAction.repeatForever(
                    SKAction.sequence(
                        [growShrinkLoop(speed: 0.3),
                         SKAction.run {
                            self.count += 1
//                            print ("completing growshrink: \(self.count)")
                            }]
                    )
                )
            )
            
            spinnyNode.position = center
            self.addChild(spinnyNode)
        }
    }
    
    func growShrinkLoop(speed: TimeInterval) -> SKAction {
        let growAction = SKAction.scale(to: 1.0, duration: speed)
        let shrinkAction = SKAction.scale(to: 0.2, duration: speed)
        let forward = SKAction.sequence([growAction, shrinkAction])
        let reverse = forward.reversed()
        return SKAction.sequence([forward, reverse])
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let currentScale = self.spinnyNode?.xScale
        self.selectedNode?.xScale = currentScale!
        self.selectedNode?.yScale = currentScale!
        
        self.previousAccuracy = currentScale!
        self.label?.attributedText = NSAttributedString(string: "accuracy: \(self.previousAccuracy)")
        print("ACCURACY: \(currentScale! * 100)")
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
