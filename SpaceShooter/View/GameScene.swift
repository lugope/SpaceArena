//
//  GameScene.swift
//  SpaceShooter
//
//  Created by Lucas Pereira on 22/03/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
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
        setupNodes()
        setupJoystick()
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
            // Control player movement
            player.position = CGPoint(
                x: player.position.x + (jsInput.velocity.x * player.velocity),
                y: player.position.y + (jsInput.velocity.y * player.velocity)
            )
            player.zRotation = jsInput.angular
            
            // Define particle emission properties
            if !player.isFireEmitterAdded {
                player.startFireEffect()
            }
            player.fireEmitter.particleBirthRate = 10 * jsInput.intensity
            player.fireEmitter.particleSpeed = -1 * jsInput.intensity
            player.fireEmitter.emissionAngle = jsInput.angular + 1.57
        }
        
        joystick.on(.end) { [unowned self] _ in
            player.stopFireEffect()
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
        // Called before each frame is rendered
    }
}
