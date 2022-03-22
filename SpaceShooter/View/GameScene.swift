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
    
    let player = PlayerShip()
    
    override func didMove(to view: SKView) {
        setupNodes()
        setupJoystick()
    }
    
    //MARK: Initial Setups
    func setupNodes() {
        backgroundColor = UIColor.darkGray
        
        player.position = CGPoint(
            x: frame.midX,
            y: frame.midY + 50
        )
        addChild(player)
    }
    
    func setupJoystick() {
        let joyStick = AnalogJoystick(
            withBase: TLAnalogJoystickComponent(diameter: JOYSTICK_BASE_SIZE, color: .clear, image: UIImage(named: "jSubstrate"))
            ,
            handle: TLAnalogJoystickComponent(diameter: JOYSTICK_HANDLE_SIZE, color: .clear, image: UIImage(named: "jStick"))
        )
        
        joyStick.zPosition = NodeZPosition.hud.rawValue
        joyStick.position = CGPoint(
            x: frame.minX + SCREEN_INSET + JOYSTICK_BASE_SIZE/2,
            y: frame.minY + SCREEN_INSET + JOYSTICK_BASE_SIZE/2
        )
        
        addChild(joyStick)
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
