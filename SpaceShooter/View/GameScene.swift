//
//  GameScene.swift
//  SpaceShooter
//
//  Created by Lucas Pereira on 22/03/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var waveCount: Int = 0
    private var isPlayerFireEnable = false
    
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
    
    var playableRect = UIScreen.main.bounds
    
    private var back = SKSpriteNode()
    private var backWalkingFrames: [SKTexture] = []
    
    
    private var bord = SKSpriteNode()
    private var bordWalkingFrames: [SKTexture] = []
    
    private var bord3 = SKSpriteNode()
    
    
    private var bord1 = SKSpriteNode()
    private var bord1WalkingFrames: [SKTexture] = []
    
    private var bord2 = SKSpriteNode()
    
    
    let BorderCategory : UInt32 = 0x1 << 1
    
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        setupNodes()
        setupJoystick()
        
        buildBack()
        animateBack()
        
        //        buildBordAnim()
        //        animateBord()
        
        //        buildBord1Anim()
        //        animateBord1()
        
        let backgroundSound = SKAudioNode(fileNamed: "backgroundSound.mp3")
        self.addChild(backgroundSound)
        
        
        //Temp code to test enemy DELETE LATER
        let testEnemy = Enemy(withType: .normal)
        testEnemy.position = CGPoint(x: frame.maxX - 50, y: frame.maxY - 50)
        addChild(testEnemy)
        
        let testEnemy2 = Enemy(withType: .normal)
        testEnemy2.position = CGPoint(x: frame.minX + 50, y: frame.minY + 50)
        addChild(testEnemy2)
    }
    
    
    
    func buildBack() {
        let backAnimatedAtlas = SKTextureAtlas(named: "BackImages")
        let f1 = backAnimatedAtlas.textureNamed("back1.png")
        f1.filteringMode = .nearest
        let f2 = backAnimatedAtlas.textureNamed("back2.png")
        f2.filteringMode = .nearest
        let f3 = backAnimatedAtlas.textureNamed("back3.png")
        f3.filteringMode = .nearest
        let f4 = backAnimatedAtlas.textureNamed("back4.png")
        f4.filteringMode = .nearest
        var walkFrames: [SKTexture] = [f1, f2, f3, f4]
        
        let numImages = backAnimatedAtlas.textureNames.count
        
        for i in 1...numImages {
            
            let backTextureName = "back\(i).png"
            walkFrames.append(backAnimatedAtlas.textureNamed(backTextureName))
            
        }
        
        backWalkingFrames = walkFrames
        
        let firstFrameTexture = backWalkingFrames[0]
        
        back = SKSpriteNode(texture: firstFrameTexture)
        back.zPosition = -1
        back.size = CGSize(width: self.size.width, height: self.size.height)
        back.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(back)
    }
    
    
    func buildBordAnim() {
        let bordAnimatedAtlas = SKTextureAtlas(named: "BordImages")
        let b1 = bordAnimatedAtlas.textureNamed("bord1.png")
        let b2 = bordAnimatedAtlas.textureNamed("bord2.png")
        let b3 = bordAnimatedAtlas.textureNamed("bord3.png")
        let b4 = bordAnimatedAtlas.textureNamed("bord4.png")
        var walkieFrames: [SKTexture] = [b1, b2, b3, b4]
        
        let numImages = bordAnimatedAtlas.textureNames.count
        
        for i in 1...numImages {
            
            let bordTextureName = "bord\(i).png"
            walkieFrames.append(bordAnimatedAtlas.textureNamed(bordTextureName))
            
        }
        
        bordWalkingFrames = walkieFrames
        
        let firstieFrameTexture = bordWalkingFrames[0]
        
        bord = SKSpriteNode(texture: firstieFrameTexture)
        bord.zPosition = 1
        bord.size = CGSize(width: 400, height: 10)
        bord.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        addChild(bord)
        
        bord3 = SKSpriteNode(texture: firstieFrameTexture)
        bord3.zPosition = 1
        bord3.size = CGSize(width: 400, height: 10)
        bord3.yScale = -1.0
        bord3.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        addChild(bord3)
    }
    
    func buildBord1Anim() {
        let bord1AnimatedAtlas = SKTextureAtlas(named: "Bord1Images")
        let a1 = bord1AnimatedAtlas.textureNamed("bord1.png")
        let a2 = bord1AnimatedAtlas.textureNamed("bord2.png")
        let a3 = bord1AnimatedAtlas.textureNamed("bord3.png")
        let a4 = bord1AnimatedAtlas.textureNamed("bord4.png")
        var walkie1Frames: [SKTexture] = [a1, a2, a3, a4]
        
        let numImages1 = bord1AnimatedAtlas.textureNames.count
        
        for i in 1...numImages1 {
            
            let bord1TextureName = "bord\(i).png"
            walkie1Frames.append(bord1AnimatedAtlas.textureNamed(bord1TextureName))
            
        }
        
        bord1WalkingFrames = walkie1Frames
        
        let firstie1FrameTexture = bord1WalkingFrames[0]
        
        bord1 = SKSpriteNode(texture: firstie1FrameTexture)
        bord1.zPosition = 1
        bord1.size = CGSize(width: 20, height: 400)
        bord1.position = CGPoint(x: frame.midX - frame.height, y: frame.midY)
        addChild(bord1)
        
        bord2 = SKSpriteNode(texture: firstie1FrameTexture)
        bord2.zPosition = 1
        bord2.size = CGSize(width: 20, height: 400)
        bord2.position = CGPoint(x: frame.midX + frame.height, y: frame.midY)
        bord2.xScale = -1.0
        addChild(bord2)
    }
    
    func animateBord1() {
        bord1.run(SKAction.repeatForever(
            SKAction.animate(with: bord1WalkingFrames,
                             timePerFrame: 0.4,
                             resize: false,
                             restore: true)),
                  withKey:"walkingInPlaceBord")
        
        bord2.run(SKAction.repeatForever(
            SKAction.animate(with: bord1WalkingFrames,
                             timePerFrame: 0.4,
                             resize: false,
                             restore: true)),
                  withKey:"walkingInPlaceBord")
        
    }
    
    func animateBord() {
        bord.run(SKAction.repeatForever(
            SKAction.animate(with: bordWalkingFrames,
                             timePerFrame: 0.4,
                             resize: false,
                             restore: true)),
                 withKey:"walkingInPlaceBord")
        
        bord3.run(SKAction.repeatForever(
            SKAction.animate(with: bordWalkingFrames,
                             timePerFrame: 0.4,
                             resize: false,
                             restore: true)),
                  withKey:"walkingInPlaceBord")
    }
    
    
    func animateBack() {
        back.run(SKAction.repeatForever(
            SKAction.animate(with: backWalkingFrames,
                             timePerFrame: 0.4,
                             resize: false,
                             restore: true)),
                 withKey:"walkingInPlaceBack")
    }
    
    
    //MARK: Initial Setups
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
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if let enemy = node as? Enemy {
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
            
            if let bullet = node as? Bullet {
                if !frame.intersects(bullet.frame) {
                    bullet.removeFromParent()
                }
            }
        }
        
        if (isPlayerFireEnable) && (player.lastFireTime + 0.3 < currentTime) {
            player.lastFireTime = currentTime
            player.fire()
        }
    }
}

