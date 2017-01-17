//
//  SlideMenuTableViewController.swift
//  SamApp
//
//  Created by Valentina Henao on 11/9/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import TwitterKit
import Fabric
import FBSDKLoginKit

class SlideMenuTableViewController: UITableViewController, UITabBarDelegate {
    

    let exampleTransitionDelegate = TransitioningDelegate()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    @IBAction func shareButton(_ sender: UIButton) {
       share()

    }
    
    func share() {
        let composer = TWTRComposer()
        
        composer.setText("I'm using SAM! Check it out... https://itunes.apple.com/us/app/sam-social-api-manager/id1181685988?ls=1&mt=8")
        
        // Called from a UIViewController
        composer.show(from: self) { result in
            if (result == TWTRComposerResult.cancelled) {
                print("Tweet composition cancelled")
            }
            else {
                print("Sending tweet!")
            }
            
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()      
        
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
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath) as! settingsTableVIewTableViewCell
        
        switch indexPath.row {
            
        case 0: cell.settingImage.image = UIImage(named: "twitterIcon")
        
        
            cell.settingTitle.text = "Share on Twitter"
        case 1:
            
            cell.settingImage.image = UIImage(named: "info")
            cell.settingTitle.text = "Info"
        
            return cell
        default: break
        
        }
    return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = appDelegate.selectedTab

        switch indexPath.row {
        case 0: share()
        case 2: if index == 0 {
            twLogout()
         } else {
            let mgr = FBSDKLoginManager()
            mgr.logOut()
            performSegue(withIdentifier: "logoutFb", sender: self)
            }
        case 1:
            
            var nameOfSocialNetwork: String {
                if index == 0 { return "Twitter" } else { return "Facebook" }
            }
        
        let alert = UIAlertController(title: "Important", message: "This values are limited by the infomation \(nameOfSocialNetwork) API allows us to collect and it might differ a little from the ones you see on their website", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
            
        default: break
            
        }
    }
    
    func twLogout() {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "floatingViewController")
        controller?.transitioningDelegate = exampleTransitionDelegate
        controller?.modalPresentationStyle = .custom
        present(controller!, animated: true, completion: nil)

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as? HeaderTableViewCell
        if appDelegate.selectedTab == 0 {

        
        header?.imageHeader.image = TwitterViewController.userImage
        header?.userHeader.text = TwitterViewController.userName
        return header
        } else {
            header?.imageHeader.image = FacebookViewController.userImage
            header?.userHeader.text = FacebookViewController.userName
            return header

        }
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
