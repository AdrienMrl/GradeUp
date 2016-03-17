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
    var leftLabel: UILabel?
    let leftLabelColor = UIColor(red: 112.0 / 255, green: 165.0 / 255, blue: 65.0 / 255, alpha: 1)
    var rightLabel: UILabel?
    let rightLabelColor = UIColor(red: 190.0 / 255, green: 61.0 / 255, blue: 55.0 / 255, alpha: 1)
    var origin: CGPoint!
    var rightAction: ((UIView) -> ())?
    var leftAction: ((UIView) -> ())?
    var leftMessage: String? {
        didSet {
            addLabel(&leftLabel, right :false)
        }
    }

    var rightMessage: String? {
        didSet {
            addLabel(&rightLabel, right: true)
        }
    }

    var upView: UIView!
    var downView: UIView!
    let addView: () -> UIView
    
    func addLabel(inout label: UILabel?, right: Bool) {
        let labelColor = right ? rightLabelColor : leftLabelColor
        let labelMessage = right ? rightMessage : leftMessage
        let angle = CGFloat(right ? M_PI_4 / 2 : -M_PI_4 / 2)
        
        label = tinderLikeStamp()
        upView.addSubview(label!)
        label!.layer.cornerRadius = 8
        label!.layer.borderWidth = 5.0
        label!.layer.borderColor = labelColor.CGColor
        label!.transform = CGAffineTransformMakeRotation(angle)
        label!.text = labelMessage
        label!.textColor = labelColor
        label!.font = label!.font.fontWithSize(30)
        label!.alpha = 0
        
        label!.translatesAutoresizingMaskIntoConstraints = false

        if (right) {
            NSLayoutConstraint.activateConstraints([
                label!.trailingAnchor.constraintEqualToAnchor(upView.trailingAnchor, constant: -30),
                label!.topAnchor.constraintEqualToAnchor(upView.topAnchor, constant: 100)])
        } else {
            NSLayoutConstraint.activateConstraints([
                label!.leadingAnchor.constraintEqualToAnchor(upView.leadingAnchor, constant: 30),
                label!.topAnchor.constraintEqualToAnchor(upView.topAnchor, constant: 100)])
        }
    }
    
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
        if rightLabel != nil {
            addLabel(&rightLabel, right: true)
        }
        
        if leftLabel != nil {
            addLabel(&leftLabel, right: false)
        }
    }
    
    func reset() {
        if leftLabel != nil {
            leftLabel?.alpha = 0
        }
        if rightLabel != nil {
            rightLabel?.alpha = 0
        }
        
        UIView.animateWithDuration(0.2, animations: {
            self.upView.center = self.origin
            self.upView.transform = CGAffineTransformMakeRotation(0)
        })
    }
    
    func swipe(right: Bool) {
        
        UIView.animateWithDuration(0.2 , animations: {
            if let labelToReveal = right ? self.leftLabel : self.rightLabel {
                labelToReveal.alpha = 1
            }
            }, completion: {
                (Bool) in
                
                UIView.animateWithDuration(0.3 , animations: {
                self.upView.center.x =
                    self.origin.x + self.upView.superview!.bounds.width * 2 * (right ? 1 : -1)
                self.rotate(self.upView)
                }, completion: {
                    (Bool) in
                    
                    right ? self.rightAction?(self.upView) : self.leftAction?(self.upView)
                    
                    self.upView.removeFromSuperview()
                    self.putViewBehind(self.downView)
 
            })
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
            if let rightLabel = self.rightLabel {
                rightLabel.alpha = (origin.x - upView.center.x) / 100 - 0.6
            }
            if let leftLabel = self.leftLabel {
                leftLabel.alpha = -(origin.x - upView.center.x) / 100 - 0.6
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
