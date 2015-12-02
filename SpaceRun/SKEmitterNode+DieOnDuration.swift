//
//  SKEmitterNode+DieOnDuration.swift
//  SpaceRun
//
//  Created by Leonardo Correa on 11/30/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

extension SKEmitterNode {
    func dieOutOn(duration : CFTimeInterval) {
        let firstWait = SKAction.waitForDuration(duration)
        let stop = SKAction.runBlock { () -> Void in
            self.particleBirthRate = 0
        }
        let secondWait = SKAction.waitForDuration(CFTimeInterval(self.particleLifetime))
        let remove = SKAction.removeFromParent()
        let dieOut = SKAction.sequence([firstWait, stop, secondWait, remove])
        self.runAction(dieOut)
    }
}
