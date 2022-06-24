//
//  GameScene.swift
//  SpaceShooter
//
//  Created by Lucas Pereira on 22/03/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player: PlayerShip = PlayerShip()
    let timerNode: SKLabelNode = SKLabelNode(fontNamed: "Arial-BoldMT")
    
    private var waveCount: Int = 2
    private var waveGap: Double = 3
    private var lastWaveTime: Double = 0
    private var isPlayerShootingEnable = false
    private var playableRect = UIScreen.main.bounds
    
    private var initialTime: Double = 0
    private var time: Double = 0 {
        didSet {
            let timef: Int = Int(time * 100)
            
            let min = timef / (60 * 100)
            let sec = timef % 6000 / 100
            let msec = timef % 100
            
            timerNode.text = String(format: "%02d:%02d.%02d", min, sec, msec)
        }
    }
    
    lazy var movJoystick: AnalogJoystick = {
        let analogJoystick = AnalogJoystick(
            withBase: TLAnalogJoystickComponent(diameter: JOYSTICK_BASE_SIZE, color: .clear, image: UIImage(named: "jSubstrate"))
            ,
            handle: TLAnalogJoystickComponent(diameter: JOYSTICK_HANDLE_SIZE, color: .clear, image: UIImage(named: "jStick"))
        )
        
        analogJoystick.zPosition = NodeZPosition.hud.rawValue
        analogJoystick.position = CGPoint(
            x: frame.minX + JOYSTICK_BASE_SIZE,
            y: frame.minY + SCREEN_INSET + JOYSTICK_BASE_SIZE
        )
        
        return analogJoystick
    }()
    
    lazy var shootJoystick: AnalogJoystick = {
        let analogJoystick = AnalogJoystick(
            withBase: TLAnalogJoystickComponent(diameter: JOYSTICK_BASE_SIZE, color: .clear, image: UIImage(named: "jSubstrate"))
            ,
            handle: TLAnalogJoystickComponent(diameter: JOYSTICK_HANDLE_SIZE, color: .clear, image: UIImage(named: "jStick"))
        )
        
        analogJoystick.zPosition = NodeZPosition.hud.rawValue
        analogJoystick.position = CGPoint(
            x: frame.maxX - JOYSTICK_BASE_SIZE,
            y: frame.minY + SCREEN_INSET + JOYSTICK_BASE_SIZE
        )
        
        return analogJoystick
    }()
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        setupNodes()
        
        let backgroundSound = SKAudioNode(fileNamed: "backgroundSound.mp3")
        self.addChild(backgroundSound)
    }
    
    //MARK: Initial Setup
    func setupNodes() {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = frame.size
        background.zPosition = NodeZPosition.background.rawValue
        addChild(background)
        
        setupPlayer()
        
        setUpTimer()
        setupMovJoystick()
        setupShootJoystick()
    }
    
    func setUpTimer() {
        timerNode.zPosition = NodeZPosition.hud.rawValue
        timerNode.text = "00:00.00"
        timerNode.position = CGPoint(
            x: frame.midX,
            y: frame.maxY - timerNode.frame.height*2 - SCREEN_INSET
        )
        addChild(timerNode)
    }
    
    func setupPlayer() {
        player.position = CGPoint(
            x: frame.midX,
            y: frame.midY
        )
        
        let xRange = SKRange(lowerLimit: frame.minX, upperLimit: frame.maxX)
        let yRange = SKRange(lowerLimit: frame.minY, upperLimit: frame.maxY)
        let yConstraint = SKConstraint.positionY(yRange)
        let xConstraint = SKConstraint.positionX(xRange)
        self.player.constraints = [xConstraint, yConstraint]
        
        addChild(player)
    }
    
    func setupMovJoystick() {
        movJoystick.zPosition = NodeZPosition.hud.rawValue
        addChild(movJoystick)
        
        movJoystick.on(.move) { [unowned self] jsInput in
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
        
        movJoystick.on(.end) { [unowned self] _ in
            player.fireEmitter.particleBirthRate = 0
        }
    }
    
    func setupShootJoystick() {
        shootJoystick.zPosition = NodeZPosition.hud.rawValue
        addChild(shootJoystick)
        
        shootJoystick.on(.move) { [unowned self] jsInput in
            if !isPlayerShootingEnable {
                isPlayerShootingEnable = true
            }
            
            player.shootAngle = jsInput.angular
        }
        
        movJoystick.on(.end) { [unowned self] _ in
            isPlayerShootingEnable = false
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
        for node in children {
            if let enemy = node as? Enemy {
                updateEnemy(enemy, withTime: currentTime)
            }
            
            if let bullet = node as? Bullet {
                updateBullet(bullet)
            }
        }
        
        updatePlayerWithTime(currentTime)
        updateTimer(currentTime)
        updateWaves(currentTime)
    }
}

extension GameScene {
    func updateTimer(_ currentTime: TimeInterval) {
        if initialTime == 0 {
            initialTime = currentTime
        }
        
        time = currentTime - initialTime
    }
    
    func updatePlayerWithTime(_ currentTime: TimeInterval) {
        if (isPlayerShootingEnable) && (player.lastFireTime + 0.3 < currentTime) {
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
    
    func updateWaves(_ currentTime: TimeInterval) {
        if (lastWaveTime + 5) < currentTime {
            spawnWave()
            lastWaveTime = currentTime
        }
    }
    
    func spawnWave() {
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
        
//        print("NEW WAVE!!")
        
        waveCount += 1
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
            
            let initialScene = InitialScene(fileNamed: "InitialScene")!
            self.scene?.view?.presentScene(initialScene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
}

