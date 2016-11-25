//
//  AnimatedTransitioning.swift
//  BlissApp
//
//  Created by Valentina Henao on 11/21/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit

class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    
    var isPresentation : Bool = false
    
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromView = fromVC?.view
        let toView = toVC?.view
        let containerView = transitionContext.containerView
        
        if isPresentation {
            containerView.addSubview(toView!)
        }
        
        let animatingVC = isPresentation ? toVC : fromVC
        let animatingView = animatingVC?.view
        
        let finalFrameForVC = transitionContext.finalFrame(for: animatingVC!)
        var initialFrameForVC = finalFrameForVC
        initialFrameForVC.origin.x = containerView.frame.width;
        
        let initialFrame = isPresentation ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresentation ? finalFrameForVC : initialFrameForVC
        
        animatingView?.frame = initialFrame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay:0, usingSpringWithDamping:300.0, initialSpringVelocity:5.0, options:UIViewAnimationOptions.allowUserInteraction, animations:{
          //  toView?.center.y += containerView.bounds.size.height
            animatingView?.frame = finalFrame
        }, completion:{ (value: Bool) in
            if !self.isPresentation {
                fromView?.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        })
    }
}
