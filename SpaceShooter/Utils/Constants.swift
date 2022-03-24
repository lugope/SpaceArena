//
//  Constants.swift
//  SpaceShooter
//
//  Created by Lucas Pereira on 22/03/22.
//

import Foundation
import SpriteKit

let JOYSTICK_BASE_SIZE: CGFloat = 50
let JOYSTICK_HANDLE_SIZE: CGFloat = 32

let SCREEN_INSET: CGFloat = 20
let DEGREES_180: CGFloat = CGFloat(Float.pi)
let DEGREES_90: CGFloat = CGFloat(Float.pi/2)
let DEGREES_45: CGFloat = CGFloat(Float.pi/4)

// Game elements Z positions
enum NodeZPosition: CGFloat {
    case background = -1, ship, hud
}

// Collision identifier
enum CollisionType: UInt32 {
    case player = 1
    case playerBullet = 2
    case enemy = 4
    case enemyBullet = 8
}

// Enemy types
enum EnemyType {
    case small, normal, big
    
    var texture: SKTexture {
        var textureName = ""
        switch self {
        case .small:
            textureName = "small_enemy"
        case .normal:
            textureName = "normal_enemy"
        case .big:
            textureName = "big_enemy"
        }
        
        let texture = SKTexture(imageNamed: textureName)
        texture.filteringMode = .nearest
        
        return texture
    }
    
    var velocity: CGFloat {
        switch self {
        case .small:
            return 0.4
        case .normal:
            return 0.3
        case .big:
            return 0.05
        }
    }
    
    var hp: Int {
        switch self {
        case .small:
            return 1
        case .normal:
            return 1
        case .big:
            return 3
        }
    }
    
    var size: Int {
        switch self {
        case .small:
            return 32
        case .normal:
            return 32
        case .big:
            return 40
        }
    }
}
