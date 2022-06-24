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
    let shootingSound: SKAudioNode
    
    var hp: Int
    var lastFireTime: Double = 0
    var shouldFire = false
    
    init(withType enemyType: EnemyType) {
        self.type = enemyType
        self.velocity = enemyType.velocity
        self.hp = enemyType.hp
        
        self.shootingSound = SKAudioNode(fileNamed: "enemyShot.wav")
        shootingSound.autoplayLooped = false
        
        super.init(
            texture: enemyType.texture,
            color: UIColor.clear,
            size: type.size
        )
        
        zPosition = NodeZPosition.ship.rawValue
        name = NodeName.enemy.rawValue
        
        physicsBody = SKPhysicsBody(rectangleOf: type.size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionType.enemy.rawValue
        physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.playerBullet.rawValue
        physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.playerBullet.rawValue
        
        self.addChild(shootingSound)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveTo(_ position: CGPoint) {
        let dx = position.x - self.position.x
        let dy = position.y - self.position.y
        let vectorAngle = -atan2(dx, dy)
        
        self.zRotation = vectorAngle
        self.position = CGPoint(
            x: self.position.x + cos(vectorAngle + DEGREES_90) * velocity,
            y: self.position.y + sin(vectorAngle + DEGREES_90) * velocity
        )
    }
    
    func fire() {
        if let world = self.scene {
            let bullet = Bullet(withType: BulletType.enemy)
            bullet.position = self.position
            
            world.addChild(bullet)
            
//            self.run(SKAction.sequence([
//                SKAction.run {
//                    self.shootingSound.run(SKAction.play())
//                }
//            ]))
            
            let dx = bullet.velocity * cos(zRotation + DEGREES_90)
            let dy = bullet.velocity * sin(zRotation + DEGREES_90)
            bullet.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        }
    }
    
    func takeDamage() -> Bool{
        self.hp -= 1
        
        if hp <= 0 {
            return true
        }
        
        return false
    }
}
