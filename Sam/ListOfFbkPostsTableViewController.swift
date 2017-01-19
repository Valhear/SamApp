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
import SDWebImage

class ListOfFbkPostsTableViewController: UITableViewController {

     let activityIN : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 100, y: 200, width: 50, height: 50)) as UIActivityIndicatorView
    
    var listOfPosts = [FbkPostObj]()
    
    //initial batch of items, from listOfPosts
    var listOfPostsToList = [FbkPost]() {
        didSet {
            self.tableView.reloadData()
            finishedDownloading()
        }
    }
    var titleForList = String()
    
    var fbkFriendsList = [FbkUser]() {
        didSet {
            self.tableView.reloadData()
            finishedDownloading()
        }
    }
    
    
    
    
    func finishedDownloading() {
        DispatchQueue.main.async { Void in
            self.activityIN.stopAnimating()
            self.activityIN.isHidden = true
        }

    }
    
    var pathNextString = String()
    
    
    let myDefaults = UserDefaults.standard
    
    var myUserImage: UIImage?
    var myName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIN.center = self.view.center
        activityIN.hidesWhenStopped = true
        activityIN.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIN.startAnimating()
        self.view.addSubview(activityIN)
        
      
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if titleForList == "Friends" {
            loadFriends()
        } else {
             loadPostsWithImages()
            
            //Load user information, name and image
            let imageURL = myDefaults.url(forKey: "imageUrl")
            do { let data = try Data.init(contentsOf: imageURL!)
                if let image = UIImage.init(data: data) {
                    myUserImage = image
                }
            } catch let error as NSError {
                print("error loading image data \(error.localizedDescription)")
                
            }
         myName = myDefaults.string(forKey: "Profilename")
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

            if post.from == myName {
                cell?.profileImage?.image = myUserImage
                
            } else {
                cell?.profileImage?.image = post.usrImage
            }
       
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .medium
            
            cell?.createdLabel?.text = "\(dateFormatter.string(from: (post.created as Date?) ?? Date() ))"
            cell?.message?.text = post.message
            if (post.imageLink == nil) {
                
                print("post.imageLink == nil")
//                cell?.link?.removeFromSuperview()
//
//                let rLabel = cell?.reactionsLabel
//                let mLabel = cell?.message
//                let views = ["rLabel": rLabel, "mLabel": mLabel]
//                cell?.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[mLabel]-[rLabel]", options: [], metrics: nil, views: views))
            } else {
              //  cell?.link?.image = post.image
                if (post.imageLink != nil) {
                let url = URL.init(string: post.imageLink!)
                    print("URLURLURL \(url)")
                    
                    
                    let myBlock: SDWebImageCompletionBlock! = {(image, error, cacheType, imageURL) -> Void in
                        
                        print("Image with url \(imageURL!.absoluteString) is loaded")
                        
                    }
                    
                cell?.link?.sd_setImage(with: url, placeholderImage: UIImage(named: "no_image-128"), options: SDWebImageOptions.progressiveDownload, completed: myBlock)
                    
                    
              
                
                
                
                }
            }
             cell?.reactionsCount?.text = "\(post.reactions ?? 0)"
            
            return cell!
        }
        
    }
 
    

    
    func loadPostsWithImages() {

        DispatchQueue.global().async { Void in

        let limit = min(10, self.listOfPosts.count)
        let slice = Array(self.listOfPosts[0..<limit])
        var list = [FbkPost]()
        for item in slice {
            let post = FbkPost()
            post.created = ((item.created as Date?) ?? Date())
            post.descriptn = item.descriptn
            post.from = item.from
            post.link = item.link
            post.reactions = item.reactions
            post.message = item.message
            post.usrImageLink = item.profileImage
            
            if let userImg = post.usrImageLink {
                if let imageURL = URL.init(string: userImg) {
                    
                    do { let data = try Data.init(contentsOf: imageURL)
                        if let image = UIImage.init(data: data) {
                            post.usrImage = image
                        }
                    } catch let error as NSError {
                        print("error loading image data \(error.localizedDescription)")
                        
                    }
                }
                
            }
            
            post.imageLink = item.imageLink
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
        self.listOfPostsToList.append(contentsOf: list)
           
        if self.listOfPosts.count > limit {
            let remainingPosts = Array(self.listOfPosts[limit..<self.listOfPosts.count])
            self.listOfPosts = remainingPosts
        } else if limit == self.listOfPosts.count {
                self.listOfPosts = []
            }
        
        
    }
    }


}
