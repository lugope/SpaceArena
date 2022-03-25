//
//  Bullet.swift
//  SpaceShooter
//
//  Created by Lucas Pereira on 24/03/22.
//

import SpriteKit

class Bullet: SKSpriteNode {
    let velocity: CGFloat
    
    init(withType bulletType: BulletType) {
        self.velocity = bulletType.velocity
        
        super.init(texture: bulletType.texture, color: UIColor.clear, size: bulletType.size)
        zPosition = NodeZPosition.bullet.rawValue
        
        physicsBody = SKPhysicsBody(rectangleOf: bulletType.size)
        physicsBody?.categoryBitMask = bulletType.categoryBitMask
        physicsBody?.collisionBitMask = bulletType.collisionBitMask
        physicsBody?.contactTestBitMask = bulletType.collisionBitMask
        physicsBody?.mass = 0.001
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
