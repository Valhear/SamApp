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
            segue()
            // performSegue(withIdentifier: "twitterLoginToMain", sender: self)
            
        } else {
            
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "4")!)
            let logInButton = TWTRLogInButton(logInCompletion: { session, error in
                if ((session) != nil) {
                    print("signed in as \(session?.userName)");
                    self.segue()
                } else {
                    print("error session == nil: \(error?.localizedDescription)");
                }
            })
            self.view.addSubview(logInButton)
            logInButton.center.x = self.view.center.x
            logInButton.alpha = 0.7
            let center = self.view.center.y
            logInButton.center.y = center+(center*2/3)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let logInButton = TWTRLogInButton { (session, error) in
//            if let unwrappedSession = session {
//                let alert = UIAlertController(title: "Logged In",
//                                              message: "User \(unwrappedSession.userName) has logged in",
//                    preferredStyle: UIAlertControllerStyle.alert
//                )
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                NSLog("Login error: %@", error!.localizedDescription);
//            }
//        }
        
            
            
            // Do any additional setup after loading the view.

        
        
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
