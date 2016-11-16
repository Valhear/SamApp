//
//  TwitterLoginViewController.swift
//  BlissApp
//
//  Created by Valentina Henao on 10/14/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import TwitterKit
import Fabric

class TwitterLoginViewController: UIViewController {

    @IBOutlet var msgLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        let store = Twitter.sharedInstance().sessionStore
        let lastSession = store.session()
        
        if lastSession != nil{
            performSegue(withIdentifier: "twitterLoginToMain", sender: self)
            
        } else {
            
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "4")!)
            
//            let imageView = UIImageView(image: UIImage(named: "back"))
//            imageView.frame = view.bounds
//            imageView.contentMode = .scaleToFill
//            view.insertSubview(imageView, at: 0)
           // view.addSubview(imageView)
            
//            let blurEffect = UIBlurEffect(style: .light)
//            let blurredEffectView = UIVisualEffectView(effect: blurEffect)
//            blurredEffectView.frame = imageView.bounds
//            blurredEffectView.effect = nil
        //    blurredEffectView.alpha = 0.95
            
         //  view.insertSubview(blurredEffectView, at: 1)
            //view.addSubview(blurredEffectView)
            
            
            
            let logInButton = TWTRLogInButton(logInCompletion: { session, error in
                if (session != nil) {
                    print("signed in as \(session?.userName)");
                    self.segue()
                } else {
                    print("error: \(error?.localizedDescription)");
                }
            })
            self.view.addSubview(logInButton)
            logInButton.center.x = self.view.center.x
            logInButton.alpha = 0.7
            let center = self.view.center.y
            logInButton.center.y = center+(center*2/3)
//            
//            self.view.addConstraint(NSLayoutConstraint(item: logInButton, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .bottom, multiplier: 1, constant: 2))
            // Do any additional setup after loading the view.
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segue() {
        performSegue(withIdentifier: "twitterLoginToMain", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
