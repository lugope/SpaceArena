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
        zPosition = NodeZPosition.ship.rawValue
        
        physicsBody = SKPhysicsBody(rectangleOf: bulletType.size)
        physicsBody?.categoryBitMask = bulletType.categoryBitMask
        physicsBody?.collisionBitMask = bulletType.collisionBitMask
        physicsBody?.contactTestBitMask = bulletType.collisionBitMask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
