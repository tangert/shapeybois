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
    private var allNodes: [Shape?]?
    
    // Guide node
    private var guideNode: Shape?
    
    // Animation parameters
    private var animationSpeed: TimeInterval!
    
    // Called on every new state change
    func newState(state: AppState) {
        
        // ONLY CONTINUE TO ADJUST THE CURRENT GAME SCENE IF YOU ARE ACTUALLY PLAYING THE GAME.
        guard state.gameplayState == .playing else { return }
        
        allNodes = [innerNode, outerNode, guideNode]
        
        // MARK: Label
        // Current accuracy from the label
        let attributes = [NSAttributedStringKey.font: UIFont(name: "Avenir", size: 50)!]
        let scoreTitle = "\(Int((state.currentAccuracy * 100).rounded()))%"
        self.currentScoreLabel?.attributedText = NSAttributedString.init(string: scoreTitle, attributes: attributes)
        
        // MARK: Lives left
        // Affect the lives component
        
        print(state.lastAction)

        if state.lastAction == "TAP_SCREEN" {
            
            print("last action was tapped")
            
            if let inner = self.innerNode {
                
                // Check if the screen was tapped
                
                // Remove everything from happening
                inner.removeAllActions()
                
                // Successful: fill in the rest
                if state.lastTapSuccessful {
                    print("\nsuccessful tap\n")
                }
                    
                    // Failure: fill up to the min boundary
                else {
                    print("\nfailure tap\n")
                }
                
                inner.run(SKAction.scale(to: 0.15, duration: 0))
                inner.run(animationSequence(speed: state.currentSpeed))
            }
            
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
    }
    
    // MARK: Main touch interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Grab the current accuracy
        guard let inner = self.innerNode else { return }
        let accuracy = Double(inner.xScale)
        
        // Grab the new shape and color for the next round
        let newColor = SKColor.random
        let newShape = ShapeType.random()
        
        // Dispatch the actions
        mainStore.dispatch( tapScreen(payload: ["accuracy": accuracy as AnyObject]) )
        mainStore.dispatch( setCurrentShape(payload: ["type": newShape as AnyObject]) )
        mainStore.dispatch( setCurrentColor(payload: ["color": newColor]) )
        
        // Increase the speed if the accuracy of the current tap is large enough
        if accuracy >= mainStore.state.currentDifficulty.rawValue {
            
            if mainStore.state.currentSpeed > 0.15 {
                mainStore.dispatch(
                    increaseSpeed(payload: ["amount": mainStore.state.currentSpeed*0.025 as AnyObject])
                )
            }
            
            mainStore.dispatch( tapSuccessful() )

        } else {
            
            mainStore.dispatch( tapFailure() )
            
        }
        

    }
    
    // MARK: View lifecycle functions
    // Called before move
    override func willMove(from view: SKView) {
        mainStore.unsubscribe(self)
    }
    
    // Called right after load
    override func didMove(to view: SKView) {
        
        mainStore.subscribe(self)
        mainStore.dispatch( adjustGameplayState(payload: ["state": GameplayState.playing as AnyObject]))
        
        // Create shape node to use during mouse interaction
        let width = (self.size.width + self.size.height) * 0.25
        let center: CGPoint = CGPoint.init(x: frame.midX, y: frame.midY)
        let labelPosition = CGPoint.init(x: frame.midX, y: frame.midY + (frame.maxY - frame.midY)/2)

        let newColor = mainStore.state.currentColor
        let difficulty = mainStore.state.currentDifficulty
        
        // MARK: Node initialization
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
        
        // Add all of the nodes to the scene and initialize the
        if let inner = self.innerNode {
            inner.lineWidth = 2.5
            inner.run(animationSequence(speed: mainStore.state.currentSpeed))
            self.addChild(inner)
        }
        
        if let outer = self.outerNode {
            outer.lineWidth = 5
            self.addChild(outer)
        }
        
        if let guide = self.guideNode {
            guide.lineWidth = 2.5
            self.addChild(guide)
        }
        
    }
    
    // Animations
    func animationSequence(speed: TimeInterval) -> SKAction {
        return SKAction.repeatForever(
            SKAction.sequence(
                [growShrinkLoop(speed: speed),
                 SKAction.run {
                    mainStore.dispatch( increaseRounds() )
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
