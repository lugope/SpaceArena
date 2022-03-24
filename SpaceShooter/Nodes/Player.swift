//
//  Player.swift
//  SpaceShooter
//
//  Created by Lucas Pereira on 22/03/22.
//

import Foundation
import SpriteKit

class PlayerShip: SKSpriteNode {
    let velocity: CGFloat = 0.06
    let fireEmitter: SKEmitterNode
    
    var isFireEmitterAdded: Bool = false
    
    init() {
        let texture = SKTexture(imageNamed: "player")
        texture.filteringMode = .nearest
        
        fireEmitter = SKEmitterNode(fileNamed: "fire.sks")!
        
        super.init(
            texture: texture,
            color: UIColor.clear,
            size: CGSize(width: 32, height: 32)
        )
        
        fireEmitter.position = CGPoint(x: 0, y: -self.size.height/2)
        fireEmitter.zPosition = NodeZPosition.ship.rawValue
        
        zPosition = NodeZPosition.ship.rawValue
        
        physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionType.player.rawValue
        physicsBody?.collisionBitMask = CollisionType.enemy.rawValue | CollisionType.enemyBullet.rawValue
        physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.enemyBullet.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startFireEffect() {
        if let world = self.parent {
            fireEmitter.targetNode = world
        }
        
        self.addChild(fireEmitter)
        isFireEmitterAdded = true
    }
    
    func stopFireEffect() {
        fireEmitter.removeFromParent()
        isFireEmitterAdded = false
    }
}
