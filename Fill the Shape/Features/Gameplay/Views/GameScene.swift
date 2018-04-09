//
//  GameScene.swift
//  Fill the Shape
//
//  Created by Tyler Angert on 4/8/18.
//  Copyright © 2018 Tyler Angert. All rights reserved.
//

import SpriteKit
import GameplayKit
import ReSwift

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    
    // Main nodes
    private var innerNode : Shape?
    private var outerNode: Shape?
    private var selectedNode: Shape?
    
    // Guide node
    private var guideNode: Shape?
    
    var currentScale = 1.0
    var accuracy: CGFloat = 0
    var count = 0
    
    override func didMove(to view: SKView) {
        
        // Create shape node to use during mouse interaction
        let width = (self.size.width + self.size.height) * 0.25
        let center: CGPoint = CGPoint.init(x: frame.midX, y: frame.midY)

        let newColor = SKColor.random
        let difficulty = mainStore.state.currentDifficulty
        
        // Inner node setup
        self.innerNode = Shape.init(type: .circle, purpose: .inner, parentRect: frame, position: center, width: width)
        self.innerNode?.setColor(color: newColor)

        // Outer node setup
        self.outerNode = Shape.init(type: .circle, purpose: .outer, parentRect: frame, position: center, width: width)
        self.outerNode?.setColor(color: newColor)
        
        // Guide node setup
        let guideNodeWidth = width * CGFloat(difficulty.rawValue)
        self.guideNode = Shape.init(type: .circle, purpose: .guide, parentRect: frame, position: center, width: guideNodeWidth )
        self.guideNode?.setColor(color: mapDifficultyToColor(setting: difficulty))

        // Label node
        self.label = SKLabelNode.init(text: "accuracy: \(self.accuracy)")
        self.label?.position = CGPoint.init(x: frame.midX, y: frame.midY+200)
        self.addChild(label!)
        
        
        if let selected = self.selectedNode {
            selected.lineWidth = 2.5
            self.addChild(selected)
        }
        
        if let border = self.outerNode {
            border.lineWidth = 5
            self.addChild(border)
        }
        
        if let guide = self.guideNode {
            guide.lineWidth = 2.5
            self.addChild(guide)
        }
        
        if let inner = self.innerNode {
            inner.lineWidth = 2.5
            inner.run(animationSequence(speed: 0.3))
            self.addChild(inner)
        }
    }
    
    // Animations
    
    func animationSequence(speed: TimeInterval) -> SKAction {
        return SKAction.repeatForever(
            SKAction.sequence(
                [growShrinkLoop(speed: 0.3),
                 SKAction.run {
                    self.count += 1
                    }]
            )
        )
    }
    
    func growShrinkLoop(speed: TimeInterval) -> SKAction {
        
        let growAction = SKAction.scale(to: 1.0, duration: speed)
        let shrinkAction = SKAction.scale(to: 0.25, duration: speed)
        let forward = SKAction.sequence([growAction, shrinkAction])
        let reverse = forward.reversed()
        return SKAction.sequence([forward, reverse])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let currentScale = self.innerNode?.xScale
        self.selectedNode?.xScale = currentScale!
        self.selectedNode?.yScale = currentScale!
        self.accuracy = CGFloat(currentScale!)
        self.label?.attributedText = NSAttributedString(string: "accuracy: \(self.accuracy)")
        
        let newColor = SKColor.random
        let newShape = ShapeType.random()
        self.selectedNode = nil
        
        self.outerNode?.setNewShape(type: newShape)
        self.outerNode?.setColor(color: newColor)
        
        self.innerNode?.setNewShape(type: newShape)
        self.innerNode?.setColor(color: newColor)
        
        self.guideNode?.setNewShape(type: newShape)
        
        let tap = TAP_SCREEN(accuracy: Double(self.accuracy))
        mainStore.dispatch(tap)
        
        print("ACCURACY: \(currentScale! * 100)")
        
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
