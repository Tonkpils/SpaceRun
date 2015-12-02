//
//  GameScene.swift
//  SpaceRun
//
//  Created by Leonardo Correa on 11/29/15.
//  Copyright (c) 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene {

    weak var shipTouch : UITouch?

    var tapGesture : UITapGestureRecognizer!

    var easyMode : Bool?

    var endGameCallback : dispatch_block_t?

    var lastUpdateTime : CFTimeInterval = 0
    var lastShotFiredTime : CFTimeInterval = 0
    var shipFireRate : CGFloat = 0.5

    let shootSound = SKAction.playSoundFileNamed("shoot.m4a", waitForCompletion: false)
    let shipExplodeSound = SKAction.playSoundFileNamed("shipExplode.m4a", waitForCompletion: false)
    let obstacleExplodeSound = SKAction.playSoundFileNamed("obstacleExplode.m4a", waitForCompletion: false)

    let shipExplodeTemplate = SKEmitterNode(fileNamed: "ShipExplode.sks") as SKEmitterNode!
    let obstacleExplodeTemplate = SKEmitterNode(fileNamed: "ObstacleExplode.sks") as SKEmitterNode!

    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blackColor()

        let starField = StarField()
        self.addChild(starField)


        let ship = SKSpriteNode(imageNamed: "Spaceship.png")
        ship.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        ship.size = CGSize(width: 40, height: 40)
        ship.name = "ship"

        let thrust = SKEmitterNode(fileNamed: "Thrust.sks") as SKEmitterNode!

        thrust.position = CGPoint(x: 0, y: -20)
        ship.addChild(thrust)

        self.addChild(ship)

        let hud = HUDNode()
        hud.name = "hud"
        hud.zPosition = 100
        hud.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(hud)

        hud.layoutForScene()
        hud.startGame()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        self.shipTouch = touches.first
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = currentTime
        }
        let timeDelta = currentTime - self.lastUpdateTime

        if let shipTouch = self.shipTouch {
            self.moveShipTowards(shipTouch.locationInNode(self), by: timeDelta)
            if CGFloat(currentTime - self.lastShotFiredTime) > shipFireRate {
                self.shoot()
                self.lastShotFiredTime = currentTime
            }

        }

        var thingProbability : Int
        if let easyMode = self.easyMode where easyMode == true {
            thingProbability = 15
        } else {
            thingProbability = 30
        }

        if Int(arc4random_uniform(1000)) <= thingProbability {
            dropThing()
        }

        self.checkCollitions()

        self.lastUpdateTime = currentTime


    }

    func dropThing() {
        let dice = arc4random_uniform(100)
        if dice < 5 {
            dropPowerUp()
        }else if dice < 20 {
            dropEnemyShip()
        } else {
            dropAsteroid()
        }
    }

    func dropPowerUp() {
        let sideSize : CGFloat = 30
        let startX = CGFloat(arc4random_uniform(UInt32(self.size.width - CGFloat(60))) + 30)
        let startY = CGFloat(self.size.height + sideSize)
        let endY = CGFloat(0 - sideSize)

        let powerUp = SKSpriteNode(imageNamed: "powerup")
        powerUp.name = "powerup"
        powerUp.size = CGSize(width: sideSize, height: sideSize)
        powerUp.position = CGPoint(x: startX, y: startY)
        self.addChild(powerUp)

        let move = SKAction.moveTo(CGPoint(x: startX, y: endY), duration: 6)
        let spin = SKAction.rotateByAngle(-1, duration: 1)
        let remove = SKAction.removeFromParent()

        let spinForever = SKAction.repeatActionForever(spin)
        let travelAndRemove = SKAction.sequence([move, remove])
        let all = SKAction.group([spinForever, travelAndRemove])

        powerUp.runAction(all)
    }

    func dropEnemyShip() {
        let sideSize : CGFloat = 30
        let startX : CGFloat = CGFloat(arc4random_uniform(UInt32(self.size.width - CGFloat(40))) + 20)
        let startY : CGFloat = self.size.height + sideSize
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.size = CGSize(width: sideSize, height: sideSize)
        enemy.position = CGPoint(x: startX, y: startY)
        enemy.name = "obstacle"
        addChild(enemy)

        let shipPath : CGPathRef = buildEnemyShipMovementPath()
        let followPath = SKAction.followPath(shipPath, asOffset: true, orientToPath: true, duration: 7)
        let remove = SKAction.removeFromParent()
        let all = SKAction.sequence([followPath, remove])
        enemy.runAction(all)
    }

    func buildEnemyShipMovementPath() -> CGPathRef {
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 0.5, y: -0.5))
        bezierPath.addCurveToPoint(CGPoint(x: -2.5, y: -59.5), controlPoint1: CGPoint(x: 0.5, y: -0.5), controlPoint2: CGPoint(x: 4.55, y: -29.48))
        bezierPath.addCurveToPoint(CGPoint(x: -27.5, y: -154.5), controlPoint1: CGPoint(x: -9.55, y: -89.52), controlPoint2: CGPoint(x: -43.32, y: -115.43))
        bezierPath.addCurveToPoint(CGPoint(x: 30.5, y: -243.5), controlPoint1: CGPoint(x: -11.68, y: -193.57), controlPoint2: CGPoint(x: 17.28, y: -186.95))
        bezierPath.addCurveToPoint(CGPoint(x: -52.5, y: -379.5), controlPoint1: CGPoint(x: 43.72, y: -300.05), controlPoint2: CGPoint(x: -47.71, y: -335.76))
        bezierPath.addCurveToPoint(CGPoint(x: 54.5, y: -449.5), controlPoint1: CGPoint(x: -57.29, y: -423.24), controlPoint2: CGPoint(x: -8.14, y: -482.24))
        bezierPath.addCurveToPoint(CGPoint(x: -5.5, y: -348.5), controlPoint1: CGPoint(x: 117.14, y: -416.55), controlPoint2: CGPoint(x: 52.25, y: -308.62))
        bezierPath.addCurveToPoint(CGPoint(x: 10.5, y: -494.5), controlPoint1: CGPoint(x: -63.25, y: -388.38), controlPoint2: CGPoint(x: -14.48, y: -457.43))
        bezierPath.addCurveToPoint(CGPoint(x: 0.5, y: -559.5), controlPoint1: CGPoint(x: 23.74, y: -514.16), controlPoint2: CGPoint(x: 6.93, y: -537.57))
        bezierPath.addCurveToPoint(CGPoint(x: -2.5, y: -644.5), controlPoint1: CGPoint(x: -5.2, y: -578.93), controlPoint2: CGPoint(x: -2.5, y: -644.5))
        return bezierPath.CGPath
    }

    func checkCollitions() {
        guard let ship = self.childNodeWithName("ship") else {
            return
        }

        self.enumerateChildNodesWithName("powerup") { (powerup, stop) -> Void in
            if ship.intersectsNode(powerup) {
                powerup.removeFromParent()
                self.shipFireRate = 0.1

                let powerdown = SKAction.runBlock({ () -> Void in
                    self.shipFireRate = 0.5
                })

                let wait = SKAction.waitForDuration(5)
                let waitAndPowerdown = SKAction.sequence([wait, powerdown])
                ship.removeActionForKey("waitAndPowerdown")
                ship.runAction(waitAndPowerdown, withKey: "waitAndPowerdown")

            }
        }


        self.enumerateChildNodesWithName("obstacle") { (obstacle, stop) -> Void in
            if ship.intersectsNode(obstacle) {
                self.shipTouch = nil

                self.endGame()

                ship.removeFromParent()
                obstacle.removeFromParent()
                self.runAction(self.shipExplodeSound)
                let explosion = self.shipExplodeTemplate.copy() as! SKEmitterNode
                explosion.position = ship.position
                explosion.dieOutOn(0.3)
                self.addChild(explosion)
            }

            self.enumerateChildNodesWithName("photon") { (photon, stop) -> Void in
                if photon.intersectsNode(obstacle) {
                    photon.removeFromParent()
                    obstacle.removeFromParent()
                    self.runAction(self.obstacleExplodeSound)
                    let explosion = self.obstacleExplodeTemplate.copy() as! SKEmitterNode
                    explosion.position = obstacle.position
                    explosion.dieOutOn(0.1)
                    self.addChild(explosion)
                    stop.memory = true
                    guard let hud = self.childNodeWithName("hud") as? HUDNode else {
                        return
                    }
                    let score = Int(10 * hud.elapsedTime * (self.easyMode! ? 1 : 2))
                    hud.addPoints(score)
                }

            }
        }
    }

    func dropAsteroid() {
        let sideSize : CGFloat = 15 + CGFloat(arc4random_uniform(30))
        let maxX : CGFloat = self.size.width
        let quarterX : CGFloat = maxX / 4
        let startX : CGFloat = CGFloat(arc4random_uniform(UInt32(maxX + (quarterX * 2)))) - quarterX
        let startY : CGFloat = self.size.height + sideSize
        let endX : CGFloat = CGFloat(arc4random_uniform(UInt32(maxX)))
        let endY : CGFloat = 0 - sideSize

        let asteroid = SKSpriteNode(imageNamed: "asteroid")
        asteroid.size = CGSize(width: sideSize, height: sideSize)
        asteroid.position = CGPoint(x: startX, y: startY)
        asteroid.name = "obstacle"
        self.addChild(asteroid)

        let move = SKAction.moveTo(CGPoint(x: endX, y: endY), duration: CFTimeInterval(3 + Int(arc4random_uniform(4))))
        let remove = SKAction.removeFromParent()
        let travelAndRemove = SKAction.sequence([move, remove])
        let spin = SKAction.rotateByAngle(3, duration: CFTimeInterval(Int(arc4random_uniform(2) + 1)))
        let spinForever = SKAction.repeatActionForever(spin)
        let all = SKAction.group([spinForever, travelAndRemove])
        asteroid.runAction(all)
    }

    func shoot() {
        guard let ship = self.childNodeWithName("ship") else {
            return
        }

        let photon = SKSpriteNode(imageNamed: "photon")
        photon.name = "photon"
        photon.position = ship.position
        self.addChild(photon)

        let fly = SKAction.moveByX(0, y: self.size.height+photon.size.height, duration: 0.5)
        let remove = SKAction.removeFromParent()
        let flyAndRemove = SKAction.sequence([fly, remove])
        photon.runAction(flyAndRemove)
        self.runAction(shootSound)
    }

    func moveShipTowards(point : CGPoint, by timeDelta: CFTimeInterval) {
        let shipSpeed : CGFloat = 360 // points per second
        guard let ship = self.childNodeWithName("ship") else {
            return
        }
        let distanceLeft = sqrt(pow(ship.position.x - point.x, 2) + pow(ship.position.y - point.y, 2))
        if distanceLeft > 4 {
            let distanceToTravel = CGFloat(timeDelta) * shipSpeed
            let angle = atan2(point.y - ship.position.y, point.x - ship.position.x)
            let yOffset = distanceToTravel * sin(angle)
            let xOffset = distanceToTravel * cos(angle)

            ship.position = CGPoint(x: ship.position.x + xOffset, y: ship.position.y + yOffset)
        }
    }

    func endGame() {
        self.tapGesture = UITapGestureRecognizer(target: self, action: "tapped")
        self.view?.addGestureRecognizer(tapGesture)

        let gameOverNode = GameOverNode()
        gameOverNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(gameOverNode)
        guard let hud = childNodeWithName("hud") as? HUDNode else {
            return
        }
        hud.endGame()
    }

    func tapped() {
        guard let endGameCallback = self.endGameCallback else {
            assert(false, "Forgot to set endGameCallback")
        }

        endGameCallback()
    }
}
