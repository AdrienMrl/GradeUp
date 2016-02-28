//
//  TinderSwipe.swift
//  GradeUp
//
//  Created by Adrien morel on 2/20/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit


class Swiper: NSObject {

    
    var target: UIView!
    var att: UIAttachmentBehavior!
    var origin: CGPoint!
    var rightAction: (() -> ())?
    var leftAction: (() -> ())?
    var nextView: UIView!
    
    func cloneView(view: UIView) -> UIView {
        let newView = NSKeyedUnarchiver.unarchiveObjectWithData(NSKeyedArchiver.archivedDataWithRootObject(view)) as! MagicWavesView
        newView.delegate = (view as! MagicWavesView).delegate
        return newView
    }
    
    init(target: UIView) {

        super.init()

        putViewBehind(target)
        origin = target.center
    }

    func getRandomColor() -> UIColor{

        let randomRed:CGFloat = CGFloat(drand48())

        let randomGreen:CGFloat = CGFloat(drand48())

        let randomBlue:CGFloat = CGFloat(drand48())

        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)

    }
    
    func putViewBehind(which: UIView) {

        self.target = which
        let pg = UIPanGestureRecognizer(target: self, action:"drag:")
        which.addGestureRecognizer(pg)
        nextView = cloneView(self.target)
        
        nextView.backgroundColor = getRandomColor()
        self.target.superview!.insertSubview(nextView, belowSubview: self.target)        
    }
    
    func reset() {
        
        UIView.animateWithDuration(0.2, animations: {
            self.target.center = self.origin
            self.target.transform = CGAffineTransformMakeRotation(0)
        })
    }
    
    func swipe(right: Bool) {
        
        
        UIView.animateWithDuration(0.3, animations: {
            self.target.center.x =
                self.origin.x + self.target.superview!.bounds.width * 2 * (right ? 1 : -1)
            right ? self.rightAction?() : self.leftAction?()
            self.rotate(self.target)
        }, completion: {
                (Bool) in
                self.target.hidden = true
                self.putViewBehind(self.nextView)
        })
    }
    
    func rotate(view: UIView) {
        
        let c = view.center
        let degrees: Double = 10 * (Double(c.x) - Double(origin.x)) / (Double(target.superview!.bounds.width) - Double(origin.x))
        view.transform = CGAffineTransformMakeRotation(CGFloat(degrees * M_PI / 180.0))
    }
    
    func drag(p: UIPanGestureRecognizer!) {
        
        switch p.state {
            
            case .Began:
                origin = target.center
            
            case .Changed:
                
                let delta = p.translationInView(target.superview)
                var c = target.center
                c.x += delta.x;
                target.center = c
                p.setTranslation(CGPointZero, inView: target.superview)
            
                rotate(target)

            case .Ended:
                
                let offset = origin.x - target.center.x
                if abs(offset) > (target.superview!.bounds.width - origin.x) / 2 {
                    swipe(offset < 0)
                } else {
                    reset()
                }
            
            default:
                reset()
        }
    
    }

}
