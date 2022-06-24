//
//  InitialScene.swift
//  SpaceShooter
//
//  Created by Lucas Pereira on 24/06/22.
//

import Foundation
import SpriteKit

class InitialScene: SKScene {
    var bestTime = 0
    
    let message: SKLabelNode = SKLabelNode(fontNamed: "Arial-BoldMT")
    
    override func didMove(to view: SKView) {
        message.text = "Tap to start!"
        message.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(message)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            print("Touch detected")
        }
        
        print("Touch detected")
        let gameScene = GameScene(fileNamed: "GameScene")!
        self.scene?.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.0))
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
