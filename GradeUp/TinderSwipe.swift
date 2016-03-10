//
//  TinderSwipe.swift
//  GradeUp
//
//  Created by Adrien morel on 2/20/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit


class Swiper: NSObject {

    
    var att: UIAttachmentBehavior!
    var leftMessage: String?
    var rightMessage: String?
    var leftLabel: UILabel?
    var rightLabel: UILabel?
    var origin: CGPoint!
    var rightAction: (() -> ())?
    var leftAction: (() -> ())?
    
    var upView: UIView! {
        
        get {
            return self.upView
        }
        
        set {
            if let leftMessage = self.leftMessage {
                
        // Got it stamp
        let gotItLabel = UILabel()
        upView.addSubview(gotItLabel)
        gotItLabel.text = "I got it !"
        gotItLabel.textColor = UIColor.whiteColor()
        gotItLabel.font = gotItLabel.font.fontWithSize(30)
        gotItLabel.alpha = 0
        
        gotItLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            gotItLabel.leadingAnchor.constraintEqualToAnchor(upView.leadingAnchor, constant: 30),
            gotItLabel.topAnchor.constraintEqualToAnchor(upView.topAnchor, constant: 100)])
        
            }
        }
    }
    
    var downView: UIView!
    
    let addView: () -> UIView
    
    init(addView: () -> UIView) {

        self.addView = addView
        
        super.init()

        putViewBehind(addView())

        origin = upView.center
    }

    var pg: UIPanGestureRecognizer!
    
    func putViewBehind(which: UIView) {

        self.upView = which
        which.superview!.bringSubviewToFront(which)
        which.userInteractionEnabled = true
        pg = UIPanGestureRecognizer(target: self, action: Selector("drag:"))
        which.addGestureRecognizer(pg)
        
        downView = addView()
        downView.superview!.sendSubviewToBack(downView)
    }
    
    func reset() {
        
        UIView.animateWithDuration(0.2, animations: {
            self.upView.center = self.origin
            self.upView.transform = CGAffineTransformMakeRotation(0)
        })
    }
    
    func swipe(right: Bool) {
        
        
        UIView.animateWithDuration(0.3 , animations: {
            self.upView.center.x =
                self.origin.x + self.upView.superview!.bounds.width * 2 * (right ? 1 : -1)
            self.rotate(self.upView)
            
        }, completion: {
                (Bool) in
        
            right ? self.rightAction?() : self.leftAction?()
            
            self.upView.removeFromSuperview()
            self.putViewBehind(self.downView)

        })
    }
    
    func rotate(view: UIView) {
        
        let c = view.center
        let degrees: Double = 10 * (Double(c.x) - Double(origin.x)) / (Double(upView.superview!.bounds.width) - Double(origin.x))
        view.transform = CGAffineTransformMakeRotation(CGFloat(degrees * M_PI / 180.0))
    }

    func drag(p: UIPanGestureRecognizer!) {
        
        switch p.state {
            
            case .Began:
                origin = upView.center
            
            case .Changed:
                if (origin.x - upView.center.x < 0) {
                    //upView.subviews = abs(origin.x - upView.center.x)
                }
                let delta = p.translationInView(upView.superview)
                var c = upView.center
                c.x += delta.x
                c.y += delta.y
                upView.center = c
                p.setTranslation(CGPointZero, inView: upView.superview)
            
                rotate(upView)

            case .Ended:
                
                let offset = origin.x - upView.center.x
                if abs(offset) > (upView.superview!.bounds.width - origin.x) / 2 {
                    swipe(offset < 0)
                } else {
                    reset()
                }
            
            default:
                reset()
        }
    
    }

}
