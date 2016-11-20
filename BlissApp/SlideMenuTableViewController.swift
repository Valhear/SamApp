//
//  SlideMenuTableViewController.swift
//  BlissApp
//
//  Created by Valentina Henao on 11/9/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import TwitterKit
import Fabric

class SlideMenuTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        print("userName UserName \(TwitterViewController.userName)")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        logout()
        
       
    }
    
    func logout() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let store = Twitter.sharedInstance().sessionStore
            if let userID = store.session()?.userID {
                //    Twitter.sharedInstance().log
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }

                let url = URL(string: "prefs:root=WIFI")
                let url2 = URL(string: UIApplicationOpenSettingsURLString)
                let url3 = URL(string: "prefs:root=WIFI")
                let url4 = NSURL(string: UIApplicationOpenSettingsURLString)
                print(url2)
                
//                UIApplication.shared.open(url4! as URL, options: [:], completionHandler: nil)
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                        store.logOutUserID(userID)
                    })
                
                self.performSegue(withIdentifier: "logout", sender: self)
            }
            }}))
            
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as? HeaderTableViewCell
        
        header?.imageHeader.image = TwitterViewController.userImage
        header?.userHeader.text = TwitterViewController.userName
        
                return header

        
    }
   
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 200.0
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
