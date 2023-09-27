//
//  GameScene.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {

    //@IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: Raw Motion Functions
    let motion = CMMotionManager()
    func startMotionUpdates(){
        // if motion is available, start updating the device motion
        if self.motion.isDeviceMotionAvailable{
            self.motion.deviceMotionUpdateInterval = 0.2
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: self.handleMotion )
        }
    }
    
    func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
        // make gravity in the game als the simulator gravity
        if let gravity = motionData?.gravity {
            self.physicsWorld.gravity = CGVector(dx: CGFloat(9.8*gravity.x), dy: CGFloat(9.8*gravity.y))
        }
        
//        if let userAccel = motionData?.userAcceleration{
//            // BONUS: using the acceleration to update node positions
//            
//            if (spinBlock.position.x < 0 && userAccel.x < 0) || (spinBlock.position.x > self.size.width && userAccel.x > 0)
//            {
//                // do not update the position
//                return
//            }
//            let action = SKAction.moveBy(x: userAccel.x*100, y: 0, duration: 0.1)
//            self.spinBlock.run(action, withKey: "temp")
//            // TODO: as a class, make these into buttons
//
//        }
    }
    
    
    // MARK: View Hierarchy Functions
    // this is like out "View Did Load" function
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.white
        
        // start motion for gravity
        self.startMotionUpdates()
        
        // make sides to the screen
        self.addSidesAndTop()
        
        // add some stationary blocks on left and right
        self.addStaticBlockAtPoint(CGPoint(x: size.width * 0.1, y: size.height * 0.25))
        self.addStaticBlockAtPoint(CGPoint(x: size.width * 0.9, y: size.height * 0.25))
        
        // add a spinning block
        self.addBlockAtPoint(CGPoint(x: size.width * 0.5, y: size.height * 0.35))
        
        // add in the interaction sprite
        self.addSpriteBottle()
        
        // add a scorer
        self.addScore()
        
        // update a special watched property for score
        self.score = 0
    }
    
    // MARK: Create Sprites Functions
    let spinBlock = SKSpriteNode()
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var score:Int = 0 {
        willSet(newValue){
            DispatchQueue.main.async{
                self.scoreLabel.text = "Score: \(newValue)"
            }
        }
    }
    
    func addScore(){
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.blue
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.minY+20)
        
        addChild(scoreLabel)
    }
    
    
    func addSpriteBottle(){
        let spriteA = SKSpriteNode(imageNamed: "sprite") // this is literally a sprite bottle... 😎
        
        spriteA.size = CGSize(width:size.width*0.1,height:size.height * 0.1)
        
        let randNumber = random(min: CGFloat(0.1), max: CGFloat(0.9))
        spriteA.position = CGPoint(x: size.width * randNumber, y: size.height * 0.75)
        
        spriteA.physicsBody = SKPhysicsBody(rectangleOf:spriteA.size)
        spriteA.physicsBody?.restitution = random(min: CGFloat(1.0), max: CGFloat(1.5))
        spriteA.physicsBody?.isDynamic = true
        // for collision detection we need to setup these masks
        spriteA.physicsBody?.contactTestBitMask = 0x00000001
        spriteA.physicsBody?.collisionBitMask = 0x00000001
        spriteA.physicsBody?.categoryBitMask = 0x00000001
        
        self.addChild(spriteA)
    }
    
    func addBlockAtPoint(_ point:CGPoint){
        
        spinBlock.color = UIColor.red
        spinBlock.size = CGSize(width:size.width*0.15,height:size.height * 0.05)
        spinBlock.position = point
        
        
        spinBlock.physicsBody = SKPhysicsBody(rectangleOf:spinBlock.size)
        spinBlock.physicsBody?.contactTestBitMask = 0x00000001
        spinBlock.physicsBody?.collisionBitMask = 0x00000001
        spinBlock.physicsBody?.categoryBitMask = 0x00000001
        spinBlock.physicsBody?.isDynamic = true
        spinBlock.physicsBody?.pinned = false
        spinBlock.physicsBody?.affectedByGravity = false
        spinBlock.physicsBody?.mass = 100000
        
        self.addChild(spinBlock)

    }
    
    func addStaticBlockAtPoint(_ point:CGPoint){
        let 🔲 = SKSpriteNode()
        
        🔲.color = UIColor.red
        🔲.size = CGSize(width:size.width*0.1,height:size.height * 0.05)
        🔲.position = point
        
        🔲.physicsBody = SKPhysicsBody(rectangleOf:🔲.size)
        🔲.physicsBody?.isDynamic = true
        🔲.physicsBody?.pinned = true
        🔲.physicsBody?.allowsRotation = true
        
        self.addChild(🔲)
        
    }
    
    func addSidesAndTop(){
        let left = SKSpriteNode()
        let right = SKSpriteNode()
        let top = SKSpriteNode()
        
        left.size = CGSize(width:size.width*0.1,height:size.height)
        left.position = CGPoint(x:0, y:size.height*0.5)
        
        right.size = CGSize(width:size.width*0.1,height:size.height)
        right.position = CGPoint(x:size.width, y:size.height*0.5)
        
        top.size = CGSize(width:size.width,height:size.height*0.1)
        top.position = CGPoint(x:size.width*0.5, y:size.height)
        
        for obj in [left,right,top]{
            obj.color = UIColor.red
            obj.physicsBody = SKPhysicsBody(rectangleOf:obj.size)
            obj.physicsBody?.isDynamic = true
            obj.physicsBody?.pinned = true
            obj.physicsBody?.allowsRotation = false
            self.addChild(obj)
        }
    }
    
    // MARK: =====Delegate Functions=====
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.addSpriteBottle()
    }
    
    // here is our collision function
    func didBegin(_ contact: SKPhysicsContact) {
        // if anything interacts with the spin Block, then we should update the score
        if contact.bodyA.node == spinBlock || contact.bodyB.node == spinBlock {
            self.score += 1
        }
        
        // TODO: How might we add additional scoring mechanisms?
    }
    
    func moveScoreNode(by amt: Float){
        let action = SKAction.moveBy(x: CGFloat(amt), y: 0, duration: 0.1)
        self.spinBlock.run(action, withKey: "temp")
    }
    
    // MARK: Utility Functions (thanks ray wenderlich!)
    // generate some random numbers for cor graphics floats
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(Int.max))
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
