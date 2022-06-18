//
//  GameScene.swift
//  SpaceShooter
//
//  Created by Lucas Pereira on 22/03/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var waveCount: Int = 2
    private var waveGap: Double = 3
    private var lastWaveTime: Double = 0
    private var isPlayerFireEnable = false
    private var playableRect = UIScreen.main.bounds
    
    let player: PlayerShip = PlayerShip()
    
    lazy var joystick: AnalogJoystick = {
        let analogJoystick = AnalogJoystick(
            withBase: TLAnalogJoystickComponent(diameter: JOYSTICK_BASE_SIZE, color: .clear, image: UIImage(named: "jSubstrate"))
            ,
            handle: TLAnalogJoystickComponent(diameter: JOYSTICK_HANDLE_SIZE, color: .clear, image: UIImage(named: "jStick"))
        )
        
        analogJoystick.zPosition = NodeZPosition.hud.rawValue
        analogJoystick.position = CGPoint(
            x: frame.minX + SCREEN_INSET + JOYSTICK_BASE_SIZE/2,
            y: frame.minY + SCREEN_INSET + JOYSTICK_BASE_SIZE/2
        )
        
        return analogJoystick
    }()
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        setupNodes()
        setupJoystick()
        
        let backgroundSound = SKAudioNode(fileNamed: "backgroundSound.mp3")
        self.addChild(backgroundSound)
    }
    
    //MARK: Initial Setup
    func setupNodes() {
        backgroundColor = UIColor.black
        
        player.position = CGPoint(
            x: frame.midX,
            y: frame.midY
        )
        addChild(player)
        
        let xRange = SKRange(lowerLimit: frame.midX - frame.height, upperLimit: frame.midX + frame.height)
        let yRange = SKRange(lowerLimit: frame.midY - 100, upperLimit: frame.midY + 100)
        let yConstraint = SKConstraint.positionY(yRange)
        let xConstraint = SKConstraint.positionX(xRange)
        self.player.constraints = [xConstraint, yConstraint]
        
    }
    
    func setupJoystick() {
        joystick.zPosition = NodeZPosition.hud.rawValue
        addChild(joystick)
        
        joystick.on(.move) { [unowned self] jsInput in
            isPlayerFireEnable = true
            
            // Control player movement
            player.position = CGPoint(
                x: player.position.x + (jsInput.velocity.x * player.velocity),
                y: player.position.y + (jsInput.velocity.y * player.velocity)
            )
            player.zRotation = jsInput.angular
            
            // Define particle emission properties
            if !player.isFireEmitterAdded {
                player.startPropulsionEffect()
            }
            player.fireEmitter.particleBirthRate = 10 * jsInput.intensity
            player.fireEmitter.particleSpeed = -1 * jsInput.intensity
            player.fireEmitter.emissionAngle = jsInput.angular + DEGREES_90
        }
        
        joystick.on(.end) { [unowned self] _ in
            isPlayerFireEnable = false
            player.fireEmitter.particleBirthRate = 0
        }
    }
    
    //MARK: Scene Observers
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (lastWaveTime + 5) < currentTime {
            spawnWave()
            lastWaveTime = currentTime
        }
        
        for node in children {
            
            if let enemy = node as? Enemy {
                updateEnemy(enemy, withTime: currentTime)
            }
            
            if let bullet = node as? Bullet {
                updateBullet(bullet)
            }
        }
        
        updatePlayerWithTime(currentTime)
    }
}

extension GameScene {
    func updatePlayerWithTime(_ currentTime: TimeInterval) {
        if (isPlayerFireEnable) && (player.lastFireTime + 0.3 < currentTime) {
            player.lastFireTime = currentTime
            player.fire()
        }
    }
    
    func updateBullet(_ bullet: Bullet) {
        if !frame.intersects(bullet.frame) {
            bullet.removeFromParent()
        }
    }
    
    func updateEnemy(_ enemy: Enemy, withTime currentTime: TimeInterval) {
        enemy.moveTo(player.position)
        
        if enemy.lastFireTime + 3 < currentTime {
            enemy.lastFireTime = currentTime
            
            if !enemy.shouldFire {
                enemy.shouldFire = true
                
            } else {
                enemy.fire()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        let sortedNodes = [nodeA, nodeB].sorted { $0.name ?? "" < $1.name ?? "" }
        let firstNode = sortedNodes[0]
        let secoundNode = sortedNodes[1]
        
        if secoundNode.name == NodeName.playerBullet.rawValue {
            if let enemyExplosion = SKEmitterNode(fileNamed: "Enemy_Explosion") {
                enemyExplosion.zPosition = NodeZPosition.hud.rawValue
                enemyExplosion.position = secoundNode.position
                addChild(enemyExplosion)
            }
            firstNode.removeFromParent()
            
            if let bulleExplosion = SKEmitterNode(fileNamed: "Bullet_Explosion") {
                bulleExplosion.zPosition = NodeZPosition.hud.rawValue
                bulleExplosion.position = secoundNode.position
                addChild(bulleExplosion)
            }
            secoundNode.removeFromParent()
        }
        
        if firstNode.name == NodeName.enemyBullet.rawValue {
            if let bulleExplosion = SKEmitterNode(fileNamed: "Bullet_Explosion") {
                bulleExplosion.zPosition = NodeZPosition.hud.rawValue
                bulleExplosion.position = secoundNode.position
                addChild(bulleExplosion)
            }
            secoundNode.removeFromParent()
            firstNode.removeFromParent()
        }
        
        if secoundNode.name == NodeName.player.rawValue {
            if let bulleExplosion = SKEmitterNode(fileNamed: "Bullet_Explosion") {
                bulleExplosion.zPosition = NodeZPosition.hud.rawValue
                bulleExplosion.position = secoundNode.position
                addChild(bulleExplosion)
            }
            secoundNode.removeFromParent()
            firstNode.removeFromParent()
        }
    }
    
    func spawnWave(){
        let courner1 = CGPoint(x: frame.minX, y: frame.minY)
        let courner2 = CGPoint(x: frame.minX, y: frame.maxY)
        let courner3 = CGPoint(x: frame.maxX, y: frame.minY)
        let courner4 = CGPoint(x: frame.maxX, y: frame.maxY)
        
        let courners = [courner1, courner2, courner3, courner4]
        
        for i in 1...waveCount {
            let enemy = Enemy(withType: EnemyType.normal)
            enemy.position = courners[i%4]
            addChild(enemy)
        }
        
        print("NEW WAVE!!")
        
        waveCount += 1
    }
}

