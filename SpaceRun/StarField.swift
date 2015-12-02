//
//  StarField.swift
//  SpaceRun
//
//  Created by Leonardo Correa on 11/30/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit
import Foundation

class StarField : SKNode {

    override init() {
        super.init()


        let update = SKAction.runBlock { () -> Void in
            if arc4random_uniform(10) < 3 {
                self.launchStar()
            }
        }
        let delay = SKAction.waitForDuration(0.01)
        let updateLoop = SKAction.sequence([delay, update])
        self.runAction(SKAction.repeatActionForever(updateLoop))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func launchStar() {
        guard let scene = self.scene else {
            return
        }
        let randX = CGFloat(arc4random_uniform(UInt32(scene.size.width)))
        let maxY = scene.size.height
        let randomStart = CGPoint(x: randX, y: maxY)

        let star = SKSpriteNode(imageNamed: "shootingstar")
        star.position = randomStart
        star.size = CGSize(width: 2, height: 10)
        star.alpha = 0.1 + (CGFloat(arc4random_uniform(10)) / 10.0)
        self.addChild(star)

        let destY = 0 - scene.size.height - star.size.height
        let duration = CFTimeInterval(0.1 + CGFloat(arc4random_uniform(10)) / 10.0)
        let move = SKAction.moveByX(0, y: destY, duration: duration)
        let remove = SKAction.removeFromParent()
        star.runAction(SKAction.sequence([move, remove]))
    }

}
