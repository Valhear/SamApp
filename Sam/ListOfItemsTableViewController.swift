//
//  ListOfItemsTableViewController.swift
//  SamApp
//
//  Created by Valentina Henao on 10/19/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import TwitterKit

class ListOfItemsTableViewController: UITableViewController {
    
    let activityIN : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 100, y: 200, width: 50, height: 50)) as UIActivityIndicatorView
    
    var listOfIds = [String]()
    var objectType = String()
    var titleForList = String()
    
    var tweetsList = [TWTRTweet]()
        {
        didSet {
            self.tableView.reloadData()
        finishedDownloading()
        }
    }
    var twitterUsersList = [TWTRUsr]()
        {
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        activityIN.center = self.view.center
        activityIN.hidesWhenStopped = true
        activityIN.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIN.startAnimating()
        self.view.addSubview(activityIN)
        
       
        loadTweetsAndUsers()
        navigationItem.title = titleForList
        tableView.tableFooterView = UIView()
        
    }
    
    func loadTweetsAndUsers() {
        let client = TWTRAPIClient()
        
        if objectType == "Tweets" {
            let limit = min(50, listOfIds.count)
            let slice = Array(listOfIds[0..<limit])
            
            client.loadTweets(withIDs: slice) { tweetlist, error in
                if let ts = tweetlist {
                    self.tweetsList.append(contentsOf: ts)
                } else {
                print("Failed to load tweets: \(error?.localizedDescription)")
                }
            }
            if listOfIds.count > limit {
                let remainingIds = Array(listOfIds[limit..<listOfIds.count])
                listOfIds = remainingIds
            } else if limit == listOfIds.count {
            listOfIds = []
            }
            
        } else if objectType == "Users" {
            let limit = min(50, listOfIds.count)
            let slice = Array(listOfIds[0..<limit])

            let statusesShowEndpoint = "https://api.twitter.com/1.1/users/lookup.json"
            let ids = slice.map { Int($0)! }
            let params = ["user_id": "\(ids)"]
            var clientError : NSError?
            let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(connectionError)")
                }
                do {
                    if data != nil {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [Any] {
                    print("JSONjson\(json)")
                            var list = [TWTRUsr]()
                        for j in json {
                            let tw = j as? [String: Any]
                            let usr = TWTRUsr()
                            usr.name = (tw?["name"] as? String)
                            usr.screenName = (tw?["screen_name"] as? String)
                            usr.bio = tw?["description"] as? String
                            
                            let urlString = (tw?["profile_image_url_https"] as? String)
                            let imageURL = URL.init(string: urlString!)
                            do { let data = try Data.init(contentsOf: imageURL!)
                                usr.profileImage = UIImage.init(data: data)
                            } catch let error as NSError {
                                print("error loading image data \(error.localizedDescription)")
                            }
                                list.append(usr)
                        }
                            self.twitterUsersList.append(contentsOf: list)
                        }
                    }
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            }
            
            if listOfIds.count > limit {
                let remainingIds = Array(listOfIds[limit..<listOfIds.count])
                listOfIds = remainingIds
            } else if limit == listOfIds.count {
                listOfIds = []
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        if objectType == "Tweets" {
        return tweetsList.count
        } else {
        return twitterUsersList.count
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if objectType == "Tweets" {
            if indexPath.row == tweetsList.count-1 {
                loadTweetsAndUsers()
            }
        } else {
            if indexPath.row == twitterUsersList.count-1 {
                loadTweetsAndUsers()
            }        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        if objectType == "Tweets" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath) as? TWTRTweetTableViewCell
            let tweet = tweetsList[indexPath.row]
            cell?.configure(with: tweet)
            
            return cell!
        }
        
         else if objectType == "Users" {

            let cell = tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath) as? ListTableViewCell
            let user = twitterUsersList[indexPath.row]
            cell?.cellImage?.image = user.profileImage
            cell?.bioLabel?.text = user.bio
            cell?.nameLabel?.text = user.name
            cell?.ScreenNameLabel?.text = "@\(user.screenName!)"
            
     return cell!
        }
    return (tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath) as? ListTableViewCell)!
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if objectType == "Tweets" {
        let tweet = tweetsList[indexPath.row]
        return TWTRTweetTableViewCell.height(for: tweet, style: .compact, width: self.view.bounds.width, showingActions: false)
        }
        
        return 90
    }
    
}




