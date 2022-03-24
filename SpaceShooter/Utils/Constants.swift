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
    
    
}
