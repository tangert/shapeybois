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

class GameScene: SKScene, StoreSubscriber {
    
    // Shows current score
    private var currentScoreLabel : SKLabelNode?
    
    // Main nodes
    private var innerNode : Shape?
    private var outerNode: Shape?
    private var selectedNode: Shape?
    private var allNodes: [Shape?]?
    
    // Guide node
    private var guideNode: Shape?
    
    // Called on every new state change
    func newState(state: AppState) {
        
        print("\nNEW STATE: \(state)")
        
        allNodes = [innerNode, outerNode, selectedNode, guideNode]
        
        // MARK: Label
        // Current accuracy from the label
        self.currentScoreLabel?.attributedText = NSAttributedString(string: "Accuracy: \(state.currentAccuracy)")
        
        // MARK: Lives left
        // Affect the lives component
        
        // MARK: Node properties
        for node in allNodes! {
            if let n = node {
                n.setNewShape(type: state.currentShape)
                if n.model.purpose != ShapePurpose.guide {
                    n.setColor(color: state.currentColor)
                }
            }
        }
    }
    
    // MARK: Main touch interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Grab the current accuracy
        let currentScale = self.innerNode?.xScale
        self.selectedNode?.xScale = currentScale!
        self.selectedNode?.yScale = currentScale!
        let accuracy = CGFloat(currentScale!)
        
        // Grab the new shape and color for the next round
        let newColor = SKColor.random
        let newShape = ShapeType.random()
        
        // DISPATCH ACTIONS
        mainStore.dispatch( TAP_SCREEN(accuracy: Double(accuracy)) )
        mainStore.dispatch( SET_CURRENT_SHAPE(shape: newShape) )
        mainStore.dispatch( SET_CURRENT_COLOR(color: newColor) )
        
    }
    
    // MARK: View lifecycle functions
    // Called before move
    override func willMove(from view: SKView) {
        mainStore.unsubscribe(self)
    }
    
    // Called right after load
    override func didMove(to view: SKView) {
        
        mainStore.subscribe(self)
        
        // Create shape node to use during mouse interaction
        let width = (self.size.width + self.size.height) * 0.25
        let center: CGPoint = CGPoint.init(x: frame.midX, y: frame.midY)
        let labelPosition = CGPoint.init(x: frame.midX, y: frame.midY + (frame.maxY - frame.midY)/2)

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
        self.currentScoreLabel = SKLabelNode.init(text: "accuracy: \(mainStore.state.currentAccuracy)")
        self.currentScoreLabel?.position = labelPosition
        self.addChild(currentScoreLabel!)
        
        
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
                [growShrinkLoop(speed: mainStore.state.currentSpeed),
                 SKAction.run {
                    mainStore.dispatch( INCREASE_ROUNDS() )
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

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
