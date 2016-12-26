//
//  ListOfFbkPostsTableViewController.swift
//  Sam
//
//  Created by Valentina Henao on 12/20/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ListOfFbkPostsTableViewController: UITableViewController {

     let activityIN : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 100, y: 200, width: 50, height: 50)) as UIActivityIndicatorView
    
    var listOfPosts = [FbkPostObj]()
    var titleForList = String()
    
    var fbkFriendsList = [FbkUser]() {
        didSet {
            print("fbkFriendsList.count \(fbkFriendsList.count)")
            self.tableView.reloadData()
            finishedDownloading()
        }
    }
    
    func finishedDownloading() {
        DispatchQueue.main.async { Void in
            self.activityIN.stopAnimating()
            self.activityIN.isHidden = true
        } }
    
    var pathNextString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIN.center = self.view.center
        activityIN.hidesWhenStopped = true
        activityIN.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIN.startAnimating()
        self.view.addSubview(activityIN)
        
//        if titleForList == "Friends" {
//            print("I need to load friends")
            loadFriends()
       // }
        tableView.tableFooterView = UIView()

        
        print("listOfPosts.count \(listOfPosts.count)")
        print("titleForList \(titleForList)")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if titleForList == "Friends" {
            return 58
        }
        
        return 90
    }
    
    func loadFriends() {
        let params = ["fields": "uid, picture, name", "limit": "50"]
        let path = "me/taggable_friends"
        reqFriends(path: path, params: params)
    }
    
    func reqFriends(path: String, params: [String:String]?){
        //var friendsArray = friendsArray
        
        //        if nextCursor != nil {
        //        params1["after"] = nextCursor
        //        }
        
        let request = FBSDKGraphRequest(graphPath: path, parameters: params) //taggable_friends
        let connection = FBSDKGraphRequestConnection()
        connection.add(request, completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else if result != nil {
                 print("result friends: \(result)")
                do {
                    if JSONSerialization.isValidJSONObject(result!) {
                        if let y = result as? NSDictionary {
                            let data = y.object(forKey: "data") as! NSArray
                            if data.count > 0 {
                                for i in 0..<data.count {
                                    let friend = FbkUser()
                                    let item = data[i] as! NSDictionary
                                    if let name = item["name"] as? String {
                                        friend.name = name
                                        if let picture = item["picture"] as? NSDictionary {
                                        let l = picture["data"]
                                        }
                                        self.fbkFriendsList.append(friend)
                                    }
                                
                                }
                            }
                            if let paging = y.object(forKey: "paging") as? [String:Any] {
                                if let next = paging["next"] as? String {
                                    let nextFields = next.components(separatedBy: "?")[1]
                                    self.pathNextString = "\(path)?".appending(nextFields)
                                    
                                } else {
                                    self.pathNextString = ""
                                    
                                }
                            }

                        }
                    }
                }
            }
        })
        connection.start()
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if titleForList == "Friends" {
            if indexPath.row == fbkFriendsList.count-1 {
                self.reqFriends(path: pathNextString, params: nil)
            }
        }
//            else {
//            if indexPath.row == twitterUsersList.count-1 {
//                loadTweetsAndUsers()
//            }
//        }
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
        return fbkFriendsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friends", for: indexPath) as? FbkFriendsTableViewCell
        let friend = fbkFriendsList[indexPath.row]
        cell?.friendName.text = friend.name
        // Configure the cell...

        return cell!
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
