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
    
    // MARK: Local state
    // Shows current score
    private var currentAccuracyLabel : SKLabelNode?
    private var currentScoreLabel: SKLabelNode?
    
    // Main nodes
    private var innerNode : Shape?
    private var outerNode: Shape?
    private var allNodes: [Shape?]?
    
    // Guide node
    private var guideNode: Shape?
    
    // Animation parameters
    private var ANIMATION_DECREASE_RATE = 0.03
    private var MIN_SPEED = 0.125
    
    
    // MARK: Lifecycle and state functions
    // Called on every new state change
    func newState(state: AppState) {
        
        // ONLY CONTINUE TO ADJUST THE CURRENT GAME SCENE IF YOU ARE ACTUALLY PLAYING THE GAME.
        guard state.gameplayState == .playing else { return }
        
        allNodes = [innerNode, outerNode, guideNode]
        
        // MARK: Label
        // Current accuracy from the label
        let attributes = [NSAttributedStringKey.font: UIFont(name: "Avenir", size: 50)!]
        let accuracyTitle = "\(Int((state.currentAccuracy * 100).rounded()))%"
        self.currentAccuracyLabel?.attributedText = NSAttributedString.init(string: accuracyTitle, attributes: attributes)
        
        let scoreTitle = "\(state.currentScore)"
        self.currentScoreLabel?.attributedText = NSAttributedString.init(string: scoreTitle, attributes: attributes)

        
        // MARK: Lives left
        // Affect the lives component
        
        if state.lastAction == "TAP_SCREEN" {
            
            guard let inner = self.innerNode else { return }
            guard let outer = self.outerNode else { return }
            guard let guide = self.guideNode else { return }
            
            // Shared actions
            let newNodeProps = SKAction.run({
                self.setNewShapeProperties(nodes: self.allNodes!, state: state)
            })
            
            let innerSequence = SKAction.run({
                inner.run(self.animationSequence(speed: state.currentSpeed))
            })
            
            if state.lastTapSuccessful {
                
                print("\nSUCCESSFUL TAP")
                print("Current speed: \(state.currentSpeed)")

                inner.removeAllActions()
                outer.removeAllActions()
                guide.removeAllActions()
                
                let duration = 0.5
                let greenColorize = SKAction.customAction(withDuration: duration, actionBlock: { (node, timeElapsed) in
                    let n = node as! Shape
                    let alpha = timeElapsed / CGFloat(duration)
                    n.fillColor = SKColor.green
                    n.strokeColor = SKColor.green
                })
                
                let clearColorize = SKAction.customAction(withDuration: duration, actionBlock: { (node, timeElapsed) in
                    let n = node as! Shape
                    n.fillColor = SKColor.clear
                    n.strokeColor = SKColor.clear
                })
                
                let outerSequence = SKAction.sequence([greenColorize, clearColorize, newNodeProps, innerSequence])
                
                outer.run(outerSequence)
            }
                
            else {
                
                print("\nFAILURE TAP\n")
                inner.removeAllActions()
                outer.removeAllActions()
                guide.removeAllActions()
                
                let redColorize = SKAction.customAction(withDuration: 0.25, actionBlock: { (node, timeElapsed) in
                    let n = node as! Shape
                    n.fillColor = SKColor.red
                    n.strokeColor = SKColor.red
                })
                
                let clearColorize = SKAction.customAction(withDuration: 0.25, actionBlock: { (node, timeElapsed) in
                    let n = node as! Shape
                    n.fillColor = SKColor.clear
                    n.strokeColor = SKColor.clear
                })
                
                let guideSequence = SKAction.sequence([redColorize, clearColorize, newNodeProps, innerSequence])
                
                guide.run(guideSequence)
                
            }
            
            
        }
    }
    
    func shapeColorChangeAction(from fromColor: UIColor, to toColor: UIColor, withDuration duration: TimeInterval) -> SKAction {
        
        func components(for color: UIColor) -> [CGFloat] {
            var comp = color.cgColor.components!
            // converts [white, alpha] to [red, green, blue, alpha]
            if comp.count < 4 {
                comp.insert(comp[0], at: 0)
                comp.insert(comp[0], at: 0)
            }
            return comp
        }
        func lerp(a: CGFloat, b: CGFloat, fraction: CGFloat) -> CGFloat {
            return (b-a) * fraction + a
        }
        
        let fromComp = components(for: fromColor)
        let toComp = components(for: toColor)
        let durationCGFloat = CGFloat(duration)
        return SKAction.customAction(withDuration: duration, actionBlock: { (node, elapsedTime) -> Void in
            let fraction = elapsedTime / durationCGFloat
            let transColor = UIColor(red: lerp(a: fromComp[0], b: toComp[0], fraction: fraction),
                                     green: lerp(a: fromComp[1], b: toComp[1], fraction: fraction),
                                     blue: lerp(a: fromComp[2], b: toComp[2], fraction: fraction),
                                     alpha: lerp(a: fromComp[3], b: toComp[3], fraction: fraction))
            (node as! SKShapeNode).fillColor = transColor
        })
    }

    
    func setNewShapeProperties(nodes: [Shape?], state: AppState) {
        // MARK: Node properties
        for node in nodes {
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
        guard let inner = self.innerNode else { return }
        let accuracy = Double(inner.xScale)
        
        // Grab the new shape and color for the next round
        let newColor = SKColor.random
        let newShape = ShapeType.random()
        
        // Initialize the tap payload
        var tapPayload: [String: AnyObject] = [
            "accuracy": accuracy as AnyObject,
            "successful": false as AnyObject
        ]
        
        // Increase the speed if the accuracy of the current tap is large enough
        if accuracy >= mainStore.state.currentDifficulty.rawValue {
            
            if mainStore.state.currentSpeed > MIN_SPEED {
                let decreasedSpeed = mainStore.state.currentSpeed * ANIMATION_DECREASE_RATE
                mainStore.dispatch(
                    increaseSpeed(payload: ["amount": decreasedSpeed as AnyObject])
                )
            }
            
            tapPayload["successful"] = true as AnyObject
            mainStore.dispatch(increaseScore())

        } else {
            
            tapPayload["successful"] = false as AnyObject
            
        }
        
        mainStore.dispatch( tapScreen(payload: tapPayload))
        mainStore.dispatch( setCurrentShape(payload: ["type": newShape as AnyObject]) )
        mainStore.dispatch( setCurrentColor(payload: ["color": newColor]) )

        

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

        // Accuracy label node
        self.currentAccuracyLabel = SKLabelNode.init()
        self.currentAccuracyLabel?.position = labelPosition
        self.addChild(currentAccuracyLabel!)
        
        // Score label node
        let scoreLabelPos = CGPoint.init(x: frame.midX, y: frame.midY + (frame.maxY - frame.midY)/1.5)
        self.currentScoreLabel = SKLabelNode.init()
        self.currentScoreLabel?.position = scoreLabelPos
        self.addChild(currentScoreLabel!)
        
        // Add all of the nodes to the scene and initialize the
        if let outer = self.outerNode {
            outer.lineWidth = 5
            self.addChild(outer)
        }
        
        if let guide = self.guideNode {
            guide.lineWidth = 2.5
            self.addChild(guide)
        }
        
        if let inner = self.innerNode {
            inner.lineWidth = 2.5
            inner.run(animationSequence(speed: mainStore.state.currentSpeed))
            self.addChild(inner)
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
