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

    @IBOutlet var loginButtonContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loginButtonContainerView)
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session?.userName)");
                self.segue()
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
        self.view.addSubview(logInButton)
        logInButton.center = self.view.center
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
