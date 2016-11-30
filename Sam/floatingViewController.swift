//
//  floatingViewController.swift
//  SamApp
//
//  Created by Valentina Henao on 11/21/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import TwitterKit

class floatingViewController: UIViewController {

    @IBOutlet var openSettingsButton: UIButton!
    
    @IBOutlet var closeButton: UIButton!
    
    @IBOutlet var containerView: UIView!


    init() {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = UIModalPresentationStyle.custom
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI() {

       openSettingsButton.layer.cornerRadius = 22
        containerView.layer.cornerRadius = 10
        closeButton.layer.cornerRadius = 22
        openSettingsButton.addTarget(self, action: #selector(self.logout(sender:)), for: UIControlEvents.touchUpInside)
        closeButton.addTarget(self, action: #selector(self.close(sender:)), for: UIControlEvents.touchUpInside)
        
    }
    
    func close(sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    func logout(sender: UIButton) {
    
    let store = Twitter.sharedInstance().sessionStore
    if let userID = store.session()?.userID {
        store.logOutUserID(userID)
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
        
        
        }
        self.performSegue(withIdentifier: "logout", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TwitterLoginViewController {
            vc.causedByLogout = true
        }
    }
    

}




