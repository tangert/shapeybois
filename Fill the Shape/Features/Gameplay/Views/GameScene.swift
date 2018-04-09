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

    
    override func didMove(to view: SKView) {
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        self.testShape = Shape.init(type: .circle, purpose: .inner)
        
        //Initial setup
        // Get center of screen
        let center: CGPoint = CGPoint.init(x: frame.midX, y: frame.midY)
        
        print("Test shape object: \(self.testShape)")
        
        let growAction = SKAction.scale(by: 1.0, duration: 0.2)
        let shrinkAction = SKAction.scale(by: 0.2, duration: 0.2)
        let forward = SKAction.sequence([growAction, shrinkAction])
        let reverse = forward.reversed()
        let growShrinkLoop = SKAction.repeatForever(SKAction.sequence([forward, reverse]))
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            spinnyNode.fillColor = SKColor.blue
            spinnyNode.run(growShrinkLoop)
            
            spinnyNode.position = center
            self.addChild(spinnyNode)
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print ("DRAGGING")

        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches ended")

        
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
