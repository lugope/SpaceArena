//
//  Enemy.swift
//  SpaceShooter
//
//  Created by Lucas Pereira on 24/03/22.
//

import SpriteKit

class Enemy: SKSpriteNode {
    let type: EnemyType
    let velocity: CGFloat
    var hp: Int
    
    init(withType enemyType: EnemyType) {
        self.type = enemyType
        self.velocity = enemyType.velocity
        self.hp = enemyType.hp
        
        super.init(
            texture: enemyType.texture,
            color: UIColor.clear,
            size: type.size
        )
        
        zPosition = NodeZPosition.ship.rawValue
        
        physicsBody = SKPhysicsBody(rectangleOf: type.size)
        physicsBody?.categoryBitMask = CollisionType.enemy.rawValue
        physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.playerBullet.rawValue
        physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.playerBullet.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveTo(_ position: CGPoint) {
        let dx = position.x - self.position.x
        let dy = position.y - self.position.y
        let angleEnemyPlayer = -atan2(dx, dy)
        
        self.zRotation = angleEnemyPlayer
        self.position = CGPoint(
            x: self.position.x + cos(angleEnemyPlayer + DEGREES_90) * velocity,
            y: self.position.y + sin(angleEnemyPlayer + DEGREES_90) * velocity
        )
    }
}
