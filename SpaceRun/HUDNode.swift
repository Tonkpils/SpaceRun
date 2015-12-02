//
//  HUDNode.swift
//  SpaceRun
//
//  Created by Leonardo Correa on 12/1/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class HUDNode : SKNode {

    var elapsedTime : CFTimeInterval
    var score : Int

    let scoreFormatter = NSNumberFormatter()
    let timeFormatter = NSNumberFormatter()

    override init() {
        self.score = 0
        self.elapsedTime = 0

        super.init()

        let scoreGroup = SKNode()
        scoreGroup.name = "scoreGroup"

        let scoreTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        scoreTitle.fontSize = 12
        scoreTitle.fontColor = SKColor.whiteColor()
        scoreTitle.horizontalAlignmentMode = .Left
        scoreTitle.verticalAlignmentMode = .Bottom
        scoreTitle.text = "SCORE"
        scoreTitle.position = CGPoint(x: 0, y: 4)
        scoreGroup.addChild(scoreTitle)

        let scoreValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreValue.fontSize = 20
        scoreValue.fontColor = SKColor.whiteColor()
        scoreValue.horizontalAlignmentMode = .Left
        scoreValue.verticalAlignmentMode = .Top
        scoreValue.name = "scoreValue"
        scoreValue.text = "0"
        scoreValue.position = CGPoint(x: 0, y: -4)
        scoreGroup.addChild(scoreValue)

        self.addChild(scoreGroup)

        let elapsedGroup = SKNode()
        elapsedGroup.name = "elapsedGroup"

        let elapsedTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        elapsedTitle.fontSize = 12
        elapsedTitle.fontColor = SKColor.whiteColor()
        elapsedTitle.horizontalAlignmentMode = .Right
        elapsedTitle.verticalAlignmentMode = .Bottom
        elapsedTitle.text = "TIME"
        elapsedTitle.position = CGPoint(x: 0, y: 4)
        elapsedGroup.addChild(elapsedTitle)

        let elapsedValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        elapsedValue.fontSize = 20
        elapsedValue.fontColor = SKColor.whiteColor()
        elapsedValue.horizontalAlignmentMode = .Right
        elapsedValue.verticalAlignmentMode = .Top
        elapsedValue.name = "elapsedValue"
        elapsedValue.text = "0.0s"
        elapsedValue.position = CGPoint(x: 0, y: -4)
        elapsedGroup.addChild(elapsedValue)

        self.addChild(elapsedGroup)

        scoreFormatter.numberStyle = .DecimalStyle
        timeFormatter.numberStyle = .DecimalStyle
        timeFormatter.minimumFractionDigits = 1
        timeFormatter.maximumFractionDigits = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layoutForScene() {
        guard let scene = self.scene else {
            return
        }

        let sceneSize = scene.size
        var groupSize = CGSize.zero
        guard let scoreGroup = childNodeWithName("scoreGroup") else {
            return
        }
        groupSize = scoreGroup.calculateAccumulatedFrame().size
        scoreGroup.position = CGPoint(x: 0 - sceneSize.width/2 + 20, y: sceneSize.height/2 - groupSize.height)

        guard let elapsedGroup = childNodeWithName("elapsedGroup") else {
            return
        }
        groupSize = elapsedGroup.calculateAccumulatedFrame().size
        elapsedGroup.position = CGPoint(x: sceneSize.width/2 - 20, y: sceneSize.height/2 - groupSize.height)
    }

    func addPoints(points : Int) {
        self.score += points
        guard let scoreValue = childNodeWithName("scoreGroup/scoreValue") as? SKLabelNode else {
            return
        }

        scoreValue.text = scoreFormatter.stringFromNumber(score)
        let scale = SKAction.scaleTo(1.1, duration: 0.02)
        let shrink = SKAction.scaleTo(1.0, duration: 0.07)
        let all = SKAction.sequence([scale, shrink])

        scoreValue.runAction(all)
    }

    func startGame() {
        let starTime = NSDate.timeIntervalSinceReferenceDate()
        guard let elapsedValue = childNodeWithName("elapsedGroup/elapsedValue") as? SKLabelNode else {
            return
        }
        let weakself = self
        let update = SKAction.runBlock { () -> Void in
            let now = NSDate.timeIntervalSinceReferenceDate()
            let elapsed : NSTimeInterval = now - starTime
            weakself.elapsedTime = elapsed
            elapsedValue.text = weakself.timeFormatter.stringFromNumber(elapsed)
        }
        let delay = SKAction.waitForDuration(0.05)
        let updateAndDelay = SKAction.sequence([update, delay])
        let timer = SKAction.repeatActionForever(updateAndDelay)
        runAction(timer, withKey: "elapsedGameTimer")
    }

    func endGame() {
        removeActionForKey("elapsedGameTimer")

    }

}
