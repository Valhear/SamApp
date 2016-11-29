//
//  PresentationController.swift
//  BlissApp
//
//  Created by Valentina Henao on 11/22/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
    
    
    var chromeView: UIView = UIView()
    
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController!) {
        super.init(presentedViewController:presentedViewController, presenting:presentingViewController)
        chromeView.backgroundColor = UIColor(white:0.0, alpha:0.8)
        chromeView.alpha = 0.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.chromeViewTapped(gesture:)))
        chromeView.addGestureRecognizer(tap)
    }
    
    func chromeViewTapped(gesture: UIGestureRecognizer) {
        if (gesture.state == UIGestureRecognizerState.ended) {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero
        let containerBounds = containerView?.bounds
        presentedViewFrame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: (containerBounds?.size)!)
        presentedViewFrame.origin.x = ((containerBounds?.size.width)! - (presentedViewFrame.size.width))/2
        presentedViewFrame.origin.y = ((containerBounds?.size.height)! - presentedViewFrame.size.height)/2
        
        return presentedViewFrame
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: (parentSize.width*3/4.0), height: parentSize.height*3/4)
    }
    
    override func presentationTransitionWillBegin() {
        chromeView.frame = (self.containerView?.bounds)!
        chromeView.alpha = 0.0
        containerView?.insertSubview(chromeView, at:0)
        let coordinator = presentedViewController.transitionCoordinator
        if (coordinator != nil) {
            coordinator!.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.chromeView.alpha = 1.0
            }, completion:nil)
        } else {
            chromeView.alpha = 1.0
        }
    }
    
    
    override func dismissalTransitionWillBegin() {
        let coordinator = presentedViewController.transitionCoordinator
        if (coordinator != nil) {
            coordinator!.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.chromeView.alpha = 0.0
            }, completion:nil)
        } else {
            chromeView.alpha = 0.0
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        chromeView.frame = (containerView?.bounds)!
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    
    override var shouldPresentInFullscreen: Bool {
        return true
    }
    
    override var adaptivePresentationStyle: UIModalPresentationStyle {
        return UIModalPresentationStyle.fullScreen
    }

}
