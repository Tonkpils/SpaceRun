//
//  MenuViewController.swift
//  SpaceRun
//
//  Created by Leonardo Correa on 11/30/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import UIKit
import SpriteKit

class MenuViewController: UIViewController {
    @IBOutlet weak var difficultyChooserSegmentedControl: UISegmentedControl!
    var demoView : SKView!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.demoView = SKView(frame: self.view.bounds) 
        let scene = SKScene(size: self.view.bounds.size)
        scene.backgroundColor = SKColor.blackColor()
        scene.scaleMode = .AspectFill

        let starField = StarField()
        scene.addChild(starField)

        self.demoView.presentScene(scene)

        self.view.insertSubview(demoView, atIndex: 0)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.demoView.removeFromSuperview()
        self.demoView = nil
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PlayGame" {
            if let gameViewController = segue.destinationViewController as? GameViewController {
                gameViewController.easyMode = self.difficultyChooserSegmentedControl.selectedSegmentIndex == 0
            }
        }
    }
}
