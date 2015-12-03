//
//  GameViewController.swift
//  SpaceRun
//
//  Created by Leonardo Correa on 11/29/15.
//  Copyright (c) 2015 Leonardo Correa. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var easyMode : Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true

        let blackScene = SKScene(size: skView.bounds.size)
        blackScene.backgroundColor = UIColor.blackColor()

        skView.presentScene(blackScene)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let skView = self.view as! SKView

        let openingScene = OpeningScene(size: skView.bounds.size)
        openingScene.scaleMode = .AspectFill
        let transition = SKTransition.fadeWithDuration(1)
        skView.presentScene(openingScene, transition: transition)

        openingScene.sceneEndCallback = {
            [unowned self] in
            let scene : GameScene = GameScene(size: skView.bounds.size)

            scene.endGameCallback = {
                self.navigationController?.popViewControllerAnimated(true)
            }

            scene.easyMode = self.easyMode
            scene.scaleMode = .AspectFill

            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
