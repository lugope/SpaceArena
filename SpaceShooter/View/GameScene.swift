//
//  GameScene.swift
//  SpaceShooter
//
//  Created by Lucas Pereira on 22/03/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
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
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        
        setupNodes()
        setupJoystick()
        
        //Temp code to test enemy DELETE LATER
        let testEnemy = Enemy(withType: .normal)
        testEnemy.position = CGPoint(x: frame.maxX - 50, y: frame.maxY - 50)
        addChild(testEnemy)
    }
    
    //MARK: Initial Setups
    func setupNodes() {
        backgroundColor = UIColor.black
        
        player.position = CGPoint(
            x: frame.midX,
            y: frame.midY + 50
        )
        addChild(player)
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
        for node in children {
            if let enemy = node as? Enemy {
                enemy.moveTo(player.position)
                
                if enemy.lastFireTime + 3 < currentTime {
                    enemy.lastFireTime = currentTime
                    enemy.fire()
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
