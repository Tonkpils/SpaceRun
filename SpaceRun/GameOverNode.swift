//
//  GameOverNode.swift
//  SpaceRun
//
//  Created by Leonardo Correa on 12/1/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class GameOverNode: SKNode {

    override init() {
        super.init()
        let labelNode = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        labelNode.fontSize = 32
        labelNode.fontColor = SKColor.whiteColor()
        labelNode.text = "Game Over"

        self.addChild(labelNode)

        labelNode.alpha = 0
        labelNode.xScale = 0.2
        labelNode.yScale = 0.2

        let fadeIn = SKAction.fadeAlphaTo(1, duration: 2)
        let scaleIn = SKAction.scaleTo(1, duration: 2)
        let fadeAndScale = SKAction.sequence([fadeIn, scaleIn])

        labelNode.runAction(fadeAndScale)

        let instructionsNode = SKLabelNode(fontNamed: "AvenirNext-Medium")
        instructionsNode.fontSize = 14
        instructionsNode.fontColor = SKColor.whiteColor()
        instructionsNode.text = "Tap to try again!"
        instructionsNode.position = CGPoint(x: 0, y: -45)

        self.addChild(instructionsNode)

        instructionsNode.alpha = 0
        let wait = SKAction.waitForDuration(4)
        let appear = SKAction.fadeAlphaTo(1, duration: 0.2)
        let popUp = SKAction.scaleTo(1.1, duration: 0.1)
        let dropDown = SKAction.scaleTo(1, duration: 0.1)
        let pauseAndAppear = SKAction.sequence([wait, appear, popUp, dropDown])
        instructionsNode.runAction(pauseAndAppear)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
