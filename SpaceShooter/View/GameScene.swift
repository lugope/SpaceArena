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
    
     private var back = SKSpriteNode()
     private var backWalkingFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        setupNodes()
        setupJoystick()
        
        
        
        buildBack()
        animateBack()
        
        let backgroundSound = SKAudioNode(fileNamed: "mario.mp3")
        self.addChild(backgroundSound)
    }
    
    func buildBack() {
      
//        let backAnimatedAtlas = SKTextureAtlas(named: "BackImages")
        
        let backAnimatedAtlas = SKTextureAtlas(named: "BackImages")
        let f1 = backAnimatedAtlas.textureNamed("back1.png")
        let f2 = backAnimatedAtlas.textureNamed("back2.png")
        let f3 = backAnimatedAtlas.textureNamed("back3.png")
        let f4 = backAnimatedAtlas.textureNamed("back4.png")
        var walkFrames: [SKTexture] = [f1, f2, f3, f4]
//        var walkFrames: [SKTexture] = []
        
      let numImages = backAnimatedAtlas.textureNames.count
        
      for i in 1...numImages {
          
        let backTextureName = "back\(i).png"
        walkFrames.append(backAnimatedAtlas.textureNamed(backTextureName))
          
      }
        
        backWalkingFrames = walkFrames
        
        let firstFrameTexture = backWalkingFrames[0]
        
        back = SKSpriteNode(texture: firstFrameTexture)
        back.zPosition = 0
//        back.size.height = self.size.height
//        back.size.width = self.size.width
        back.size = CGSize(width: self.size.width, height: self.size.height)
        back.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(back)
    }
    
    func animateBack() {
      back.run(SKAction.repeatForever(
        SKAction.animate(with: backWalkingFrames,
                         timePerFrame: 0.1,
                         resize: false,
                         restore: true)),
        withKey:"walkingInPlaceBack")
    }
    
    
    //MARK: Initial Setups
    func setupNodes() {
        backgroundColor = UIColor.darkGray
        
        player.position = CGPoint(
            x: frame.midX,
            y: frame.midY
        )
        addChild(player)
    }
    
    func setupJoystick() {
        
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
