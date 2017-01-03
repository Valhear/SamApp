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
    
    var listOfPosts = [FbkPostObj]() {
        didSet {
            print("listOfPosts.count == \(listOfPosts.count)")
            print("listOfPostsToList.count == \(listOfPostsToList.count)")
        }
    }

    var listOfPostsToList = [FbkPost]() {
        didSet {
            self.tableView.reloadData()
            finishedDownloading()
        }
    }
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
        
        if titleForList == "Friends" {
            loadFriends()
        } else {
           // loadPostsWithImages()
            
        }
        tableView.tableFooterView = UIView()

        
        print("listOfPosts.count \(listOfPosts.count)")
        print("titleForList \(titleForList)")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if titleForList != "Friends" {
            loadPostsWithImages()
        }
    }
    

    
    func loadFriends() {
        let params = ["fields": "uid, picture, name", "limit": "50"]
        let path = "me/taggable_friends"
        reqFriends(path: path, params: params)
    }
    
    func reqFriends(path: String, params: [String:String]?){

        
        let request = FBSDKGraphRequest(graphPath: path, parameters: params)
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
                                            if let l = picture["data"] as? NSDictionary {
                                                let url = l["url"] as! String
                                                let imageURL = URL.init(string: url)
                                                do { let data = try Data.init(contentsOf: imageURL!)
                                                    friend.image = UIImage.init(data: data)
                                                } catch let error as NSError {
                                                    print("error loading image data \(error.localizedDescription)")
                                                    
                                                }
                                                
                                            }
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
            else {
            if indexPath.row == listOfPostsToList.count-1 {
                loadPostsWithImages()
            }
        }
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
        if titleForList == "Friends" {
        return fbkFriendsList.count
        } else {
            return listOfPostsToList.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if titleForList == "Friends" {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friends", for: indexPath) as? FbkFriendsTableViewCell
        let friend = fbkFriendsList[indexPath.row]
        cell?.friendName.text = friend.name
        cell?.friendImage.image = friend.image
        // Configure the cell...

        return cell!
         } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "posts", for: indexPath) as? FbkListTableViewCell
            let post = listOfPostsToList[indexPath.row]
            cell?.nameLabel?.text = post.from
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .medium
            
            cell?.createdLabel?.text = "\(dateFormatter.string(from: (post.created as Date?) ?? Date() ))"
            cell?.message?.text = post.message
            if (post.image == nil) {
                cell?.link?.removeFromSuperview()
//                let constTop:NSLayoutConstraint = NSLayoutConstraint(item: cell?.reactionsLabel!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: cell?.message, attribute: NSLayoutAttribute.bottom, multiplier: 2, constant: 0);
//                self.view.addConstraint(constTop);
                let rLabel = cell?.reactionsLabel
                let mLabel = cell?.message
                let views = ["rLabel": rLabel, "mLabel": mLabel]
                cell?.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[mLabel]-[rLabel]", options: [], metrics: nil, views: views))
            } else {
                cell?.link?.image = post.image
            }
            
            
            
            
          //  cell?.link?.image = UIImage(named: "twitter-512")
//            if let img = post.imageLink {
//                if let imageURL = URL.init(string: img) {
//                    print("link URL Imaage\(imageURL)")
//                do { let data = try Data.init(contentsOf: imageURL)
//                    print("JUST IMAGE LINK\(imageURL)")
//                    if let image = UIImage.init(data: data) {
//                        
//                    cell?.link?.image = image
//                        
//                    }
//                } catch let error as NSError {
//                    print("error loading image data \(error.localizedDescription)")
//                    
//                }
//            }
//            }

            cell?.reactionsCount?.text = "\(post.reactions ?? 0)"
            
            return cell!
        }
        
    }
 
    func loadPostsWithImages() {
        let limit = min(10, listOfPosts.count)
        let slice = Array(listOfPosts[0..<limit])
        var list = [FbkPost]()
        for item in slice {
            let post = FbkPost()
            post.created = ((item.created as Date?) ?? Date())
            post.descriptn = item.descriptn
            post.from = item.from
            post.link = item.link
            post.reactions = item.reactions
            post.message = item.message
            if let img = item.imageLink {
                if let imageURL = URL.init(string: img) {
                    print("link URL Imaage\(imageURL)")
                    do { let data = try Data.init(contentsOf: imageURL)
                        if let image = UIImage.init(data: data) {
                          post.image = image
                            
                        }
                    } catch let error as NSError {
                        print("error loading image data \(error.localizedDescription)")
                    }
                }
            }
            list.append(post)
        }
        print("listOfPostsToList.countappend \(listOfPostsToList.count)")
        self.listOfPostsToList.append(contentsOf: list)

        if listOfPosts.count > limit {
            let remainingPosts = Array(listOfPosts[limit..<listOfPosts.count])
            listOfPosts = remainingPosts
        } else if limit == listOfPosts.count {
                listOfPosts = []
            }
        
        
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
