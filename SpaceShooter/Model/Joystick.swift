//
//  Joystick.swift
//  SpaceShooter
//
//  Created by Lucas Pereira on 22/03/22.
//

import Foundation
import SpriteKit

class Joystick: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "")
        texture.filteringMode = .nearest
        
        super.init(
            texture: texture,
            color: UIColor.clear,
            size: CGSize(width: 32, height: 32)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
