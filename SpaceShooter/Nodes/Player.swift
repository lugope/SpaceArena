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
    var lastFireTime: Double = 0
    
    init() {
        fireEmitter = SKEmitterNode(fileNamed: "fire.sks")!
        
        super.init(
            texture: SKTexture(imageNamed: "player"),
            color: UIColor.clear,
            size: CGSize(width: 32, height: 32)
        )
        
        fireEmitter.position = CGPoint(x: 0, y: -self.size.height/2)
        fireEmitter.zPosition = NodeZPosition.ship.rawValue
        
        zPosition = NodeZPosition.ship.rawValue
        name = NodeName.player.rawValue
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 32, height: 32))
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionType.player.rawValue
        physicsBody?.collisionBitMask = CollisionType.enemy.rawValue | CollisionType.enemyBullet.rawValue
        physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.enemyBullet.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startPropulsionEffect() {
        if let world = self.parent {
            fireEmitter.targetNode = world
        }
        
        self.addChild(fireEmitter)
        isFireEmitterAdded = true
    }
    
    func fire() {
        if let world = self.scene {
            let bullet = Bullet(withType: BulletType.player)
            bullet.position = position
            bullet.zRotation = zRotation
            
            world.addChild(bullet)
            
            let dx = bullet.velocity * cos(zRotation + DEGREES_90)
            let dy = bullet.velocity * sin(zRotation + DEGREES_90)
            bullet.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        }
    }
}
