//
//  FacebookViewController.swift
//  Sam
//
//  Created by Valentina Henao on 12/9/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit


class FacebookLoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
   // @IBOutlet var msgLabel: UILabel!
    let myDefaults = UserDefaults.standard
    @IBOutlet var loginButton: FBSDKLoginButton!
    override func viewDidAppear(_ animated: Bool) {
        

        
        if FBSDKAccessToken.current() == nil {
            print("user is not logged in")
            
        } else {
            performSegue(withIdentifier: "fbLoggedIn", sender: self)
            print("user is logged in, expiration date \(FBSDKAccessToken.current().expirationDate)")
        }
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if ((error) != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            performSegue(withIdentifier: "fbLoggedIn", sender: self)

        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.loginButton.delegate = self
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "4")!)
        
        
     //   loginButt.addTarget(self, action: #selector(self.selectorfbk), for: UIControlEvents.touchUpInside)
        
        loginButton.center.x = self.view.center.x
        loginButton.alpha = 0.7
        loginButton.layer.cornerRadius = 5
        let center = self.view.center.y
        loginButton.center.y = center+(center*2/3)
        loginButton.readPermissions = ["public_profile", "user_friends", "read_custom_friendlists", "user_posts"]
        self.view.addSubview(loginButton)


        // Do any additional setup after loading the view.
    }
    
    func selectorfbk() {
        print("OKFABEBOOK")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
