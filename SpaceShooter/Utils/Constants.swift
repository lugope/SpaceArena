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

// Bullet Type
enum BulletType {
    case player, enemy
    
    var texture: SKTexture {
        var textureName = ""
        
        switch self {
        case .player:
            textureName = "playerBullet"
        case .enemy:
            textureName = "enemyBullet"
        }
        
        let texture = SKTexture(imageNamed: textureName)
        texture.filteringMode = .nearest
        return texture
    }
    
    var size: CGSize {
        switch self {
        case .player:
            return CGSize(width: 4, height: 6)
        case .enemy:
            return CGSize(width: 8, height: 8)
        }
    }
    
    var categoryBitMask: UInt32 {
        switch self {
        case .player:
            return CollisionType.playerBullet.rawValue
        case .enemy:
            return CollisionType.enemyBullet.rawValue
        }
    }
    
    var collisionBitMask: UInt32 {
        switch self {
        case .player:
            return CollisionType.enemy.rawValue
        case .enemy:
            return CollisionType.player.rawValue
        }
    }
    
    var velocity: CGFloat {
        switch self {
        case .player:
            return 1
        case .enemy:
            return 0.7
        }
    }
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
    
    var size: CGSize {
        switch self {
        case .small:
            return CGSize(width: 32, height: 32)
        case .normal:
            return CGSize(width: 32, height: 32)
        case .big:
            return CGSize(width: 40, height: 40)
        }
    }
}
