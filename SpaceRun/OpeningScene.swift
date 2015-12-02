//
//  OpeningScene.swift
//  SpaceRun
//
//  Created by Leonardo Correa on 11/30/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class OpeningScene: SKScene {

    var slantedView : UIView!
    var textView : UITextView!
    var tapGesture : UITapGestureRecognizer!

    var sceneEndCallback : dispatch_block_t?

    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blackColor()

        let starField = StarField()
        self.addChild(starField)

        self.tapGesture = UITapGestureRecognizer(target: self, action: "endScene")
        self.view?.addGestureRecognizer(self.tapGesture)

        self.slantedView = UIView(frame: self.view!.bounds)
        self.slantedView.opaque = false
        self.slantedView.backgroundColor = UIColor.clearColor()
        view.addSubview(self.slantedView)

        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 500.0
        transform = CATransform3DRotate(transform, CGFloat(45.0 * M_PI / 180.0), 1.0, 0.0, 0.0)
        self.slantedView.layer.transform = transform

        self.textView = UITextView(frame: CGRectInset(self.view!.bounds, 30, 0))
        self.textView.opaque = false
        self.textView.backgroundColor = UIColor.clearColor()
        self.textView.textColor = UIColor.yellowColor()
        self.textView.font = UIFont(name: "AvenirNext-Medium", size: 20)

        self.textView.text = "A distress call comes in from thousands of light " +
            "years away. The colony is in jeopardy and needs " +
            "your help. Enemy ships and a meteor shower " +
            "threaten the work of the galaxy's greatest " +
            "scientific minds.\n\n" +
            "Will you be able to reach " +
            "them in time to save the research?\n\n" +
            "Or has the galaxy lost it's only hope?"
        self.textView.userInteractionEnabled = false
        self.textView.center = CGPoint(x: self.size.width / 2 + 15, y: self.size.height + (self.size.height / 2))
        self.slantedView.addSubview(self.textView)

        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.whiteColor().CGColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.20)
        self.slantedView.layer.mask = gradient

        UIView.animateWithDuration(20, delay: 0, options: .CurveLinear, animations: {
            () -> Void in
            self.textView.center = CGPoint(x: self.size.width / 2, y: 0 - (self.size.height / 2))
            }) { (finished) -> Void in
                if finished {
                    self.endScene()
                }
        }
    }

    override func willMoveFromView(view: SKView) {
        self.view?.removeGestureRecognizer(self.tapGesture)
        self.tapGesture = nil

        self.slantedView.removeFromSuperview()
        self.slantedView = nil
        self.textView = nil
    }

    func endScene() {
        UIView.animateWithDuration(0.3, animations: {
            () -> Void in
            self.textView.alpha = 0
            }) { (finished) -> Void in
                self.textView.layer.removeAllAnimations()
                self.sceneEndCallback!()
        }
    }

}
