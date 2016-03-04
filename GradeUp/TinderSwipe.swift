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
    var origin: CGPoint!
    var rightAction: (() -> ())?
    var leftAction: (() -> ())?
    
    var upView: UIView!
    var downView: UIView!
    
    let addView: () -> UIView
    
    init(addView: () -> UIView) {

        self.addView = addView
        
        super.init()

        putViewBehind(addView())

        origin = upView.center
    }

    func getRandomColor() -> UIColor{

        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())

        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)

    }
    var pg: UIPanGestureRecognizer!
    
    func putViewBehind(which: UIView) {

        self.upView = which
        which.userInteractionEnabled = true
        pg = UIPanGestureRecognizer(target: self, action: Selector("drag:"))
        which.addGestureRecognizer(pg)
        
        downView = addView()
        downView.superview!.sendSubviewToBack(downView)
        downView.backgroundColor = getRandomColor()
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
            
            self.upView.hidden = true
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
                
                let delta = p.translationInView(upView.superview)
                var c = upView.center
                c.x += delta.x;
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
