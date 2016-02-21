//
//  TinderSwipe.swift
//  GradeUp
//
//  Created by Adrien morel on 2/20/16.
//  Copyright © 2016 Adrien morel. All rights reserved.
//

import UIKit

class Swiper: NSObject {
    
    let target: UIView
    var att: UIAttachmentBehavior!
    var origin: CGPoint!
    
    init(target: UIView) {
        
        self.target = target

        super.init()
    }

    
    func drag(p: UIPanGestureRecognizer) {

        switch p.state {
            
            case .Began:
                origin = target.center
            
            case .Changed:
                
                let delta = p.translationInView(target.superview)
                var c = target.center
                c.x += delta.x;
                target.center = c
                p.setTranslation(CGPointZero, inView: target.superview)
                
                let degrees: Double = 10 * (Double(c.x) - Double(origin.x)) / (Double(target.superview!.bounds.width) - Double(origin.x))
                target.transform = CGAffineTransformMakeRotation(CGFloat(degrees * M_PI / 180.0))

            
            default:
                
                UIView.animateWithDuration(0.2, animations: {
                    self.target.center = self.origin
                    self.target.transform = CGAffineTransformMakeRotation(0)
                })
        }
    
    }

}
