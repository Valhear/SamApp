//
//  TwitterLoginViewController.swift
//  SamApp
//
//  Created by Valentina Henao on 10/14/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import TwitterKit
import Fabric
import FBSDKLoginKit

class TwitterLoginViewController: UIViewController {

    @IBOutlet var msgLabel: UILabel!
    
    var causedByLogout: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        if causedByLogout == true {
            causedByLogout = false
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                    let fetchRequest: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
                    do {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let managedContext = appDelegate.persistentContainer.viewContext
                        let fetchedUsers = try managedContext.fetch(fetchRequest)
                        for user in fetchedUsers {
                            
                            managedContext.delete(user)
                        }
                    } catch let error as NSError {
                        print("Could not delete \(error), \(error.userInfo)")
                    }
                    
                    
                })
            }
        }
        
        let store = Twitter.sharedInstance().sessionStore
        let lastSession = store.session()
        
        
        if lastSession != nil{
            segue()
            
        } else {
            
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "4")!)
            let logInButton = TWTRLogInButton(logInCompletion: { session, error in
                if ((session) != nil) {
                    print("signed in as \(session?.userName)");
                    
                    self.segue()
                } else {                    
                    let alert = UIAlertController(title: "Error", message: "\(error?.localizedDescription ?? "error loading session")", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
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
