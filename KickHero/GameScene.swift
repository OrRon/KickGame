//
//  GameScene.swift
//  KickHero
//
//  Created by Or on 28/03/2016.
//  Copyright (c) 2016 Or. All rights reserved.
//

import SpriteKit
import GameKit
class GameScene: SKScene {
    var ball:SKSpriteNode!
    var cross:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    
    let startingPoint = 150
    var score = 0
    let xRand = GKRandomDistribution(lowestValue: 500, highestValue: 700);
    let yRand = GKRandomDistribution(lowestValue: 200, highestValue: 500);
    override func didMoveToView(view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsWorld.gravity = CGVector(dx: -5, dy: -9.8)
        
        self.setUpScene()
        
    }
    
    func setUpScene() {
        //setting up the score table
        scoreLabel = SKLabelNode(text:"Your Score: 0")
        scoreLabel.position = CGPoint(x: startingPoint, y: 350)
        self.addChild(scoreLabel)
        
        cross = SKSpriteNode(imageNamed: "cross")
        cross.position = CGPoint(x: startingPoint, y: 25)
        self.addChild(cross)
        
        ball = SKSpriteNode(imageNamed: "Ball")
        ball.position = CGPoint(x: startingPoint, y: 25)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        ball.physicsBody?.dynamic = false
        ball.physicsBody?.friction = 0.3
        ball.physicsBody?.angularDamping = 0.2;
        ball.physicsBody?.linearDamping = 0.2;
        ball.physicsBody?.restitution = 0.8;
        self.addChild(ball)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if (self.paused) {
            self.removeAllChildren()
            self.setUpScene()
            self.paused = false
            return
        }
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.velocity = CGVector(dx: xRand.nextInt(), dy: yRand.nextInt())
        if didHit(ball, second: cross, distance: 40) {
            score = score + 1
            scoreLabel.text = "Your Score: \(score)"
            
        } else {
            self.paused = true
            //setting up the score table
            
            let gameOverLabel = SKLabelNode(text:"GAME OVER")
            gameOverLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
            self.addChild(gameOverLabel)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        cross.position.y = ball.position.y
    }
}

func SDistanceBetweenPoints(first:CGPoint, second:CGPoint) -> Float {
    return hypotf(Float(second.x - first.x), Float(second.y - first.y));
}

func didHit(first:SKNode,second:SKNode,distance:Float) -> Bool{
    return SDistanceBetweenPoints(first.position, second: second.position) < distance
}
