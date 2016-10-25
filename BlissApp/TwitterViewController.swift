//
//  TwitterViewController.swift
//  BlissApp
//
//  Created by Valentina Henao on 10/13/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import CoreData

class TwitterViewController: UIViewController {
    
  //  var managedObjectContext: NSManagedObjectContext
    //FIX, SOLO DEBO GUARDAR IDS
    var followerslist = [TwitterUser]()
    var retweetedTweets = [Tweet]()
    var mentionsTweets = [Tweet]()
    var postsTweets = [Tweet]()
    
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view4: UIView!
    
    @IBAction func updateButton(_ sender: UIButton) {
        getfollowers(sender)
        getRetweets(sender)
        getMentions(sender)
        getPosts(sender)
    }
    
    @IBAction func getfollowers(_ sender: UIButton) {
        
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            let statusesShowEndpoint = "https://api.twitter.com/1.1/followers/ids.json"
            let params = ["user_id": "\(userID)"]
            var clientError : NSError?
            let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(connectionError)")
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    print("json: \(json)")
                    if let x = json["ids"] as? NSArray {
                        let follo = x.count
                        self.followers.text = String(follo)
                        self.saveObject(ids: x as! [Int], entity: "TwitterUser", sender: "getFollowers")
                    }
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            }
        }
    }
    @IBAction func getRetweets(_ sender: UIButton) {
        
        var retweets = 0
        var ids = [Int?]()
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            // make requests with client
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/retweets_of_me.json"
            let params = ["count": "\(100)"]
            var clientError : NSError?
            let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(connectionError)")
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                    print("json: \(json)")
                        
                    for tweet in json {
                         let info = tweet as! [String:Any]
                            if let ret = info["retweet_count"] as? Int {

                                retweets += ret
                                self.retweets.text = String(retweets)
                                let id = info["id"] as? Int
                                ids.append(id)
                                print("retweets === \(retweets)")
                                print("id === \(id)")
                            }
                    }
                    self.saveObject(ids: ids as! [Int], entity: "Tweet", sender: "getRetweets")
                    
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
                
            }
        }
    }
    
    @IBAction func getMentions(_ sender: UIButton) {
        var ids = [Int?]()
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/mentions_timeline.json"
            let params = ["count": "\(100)"]
            var clientError : NSError?
            let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(connectionError)")
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                    print("json: \(json)")
                    self.mentions.text = String(json.count)

                        print("mentions === \(json.count)")
                    for item in json {
                        let info = item as! [String:Any]
                            if let id = info["id"] as? Int {
                                print("IDGONORREHA: \(id)")
                                ids.append(id)
                                }
                        }
                    self.saveObject(ids: ids as! [Int], entity: "Tweet", sender: "getMentions")
                    
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
                
            }
        }
    }

    @IBAction func getPosts(_ sender: UIButton) {
        var ids = [Int?]()
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            // make requests with client
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
            let params = ["user_id": "\(userID)"]
            var clientError : NSError?
            let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(connectionError)")
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                    print("json: \(json)")
                    self.posts.text = String(json.count)
                    
                    for item in json {
                        let info = item as! [String:Any]
                        if let id = info["id"] as? Int {
                            ids.append(id)
                        }
                    }
                    self.saveObject(ids: ids as! [Int], entity: "Tweet", sender: "getPosts")
                    
                    
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
                
            }
        }
    }
    
    @IBOutlet var weekButton: UIButton!
    
    @IBOutlet var monthButton: UIButton!
    
    @IBOutlet var yearButton: UIButton!
    
    @IBOutlet var allTimeButton: UIButton!
    
    
    @IBAction func weekButton(_ sender: UIButton) {
        monthButton.backgroundColor = UIColor.white
        yearButton.backgroundColor = UIColor.white
        allTimeButton.backgroundColor = UIColor.white
        weekButton.backgroundColor = UIColor.blue
    }
    
    @IBAction func monthButton(_ sender: UIButton) {
        monthButton.backgroundColor = UIColor.blue
        yearButton.backgroundColor = UIColor.white
        allTimeButton.backgroundColor = UIColor.white
        weekButton.backgroundColor = UIColor.white
    }
    
    @IBAction func yearButton(_ sender: UIButton) {
        monthButton.backgroundColor = UIColor.white
        yearButton.backgroundColor = UIColor.blue
        allTimeButton.backgroundColor = UIColor.white
        weekButton.backgroundColor = UIColor.white
    }
    
    @IBAction func allTimeButton(_ sender: UIButton) {
        monthButton.backgroundColor = UIColor.white
        yearButton.backgroundColor = UIColor.white
        allTimeButton.backgroundColor = UIColor.blue
        weekButton.backgroundColor = UIColor.white
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show List" {
            if let nextvc = segue.destination as? ListOfItemsTableViewController {
                
                nextvc.listOfObject = listOfTweetsToPass
            }
        }
    }
    
    var listOfTweetsToPass = [AnyObject]()
    
    @IBAction func segue(_ sender: UITapGestureRecognizer) {
    
                switch (sender.view?.tag)! as Int {
                case 1: listOfTweetsToPass = followerslist
                case 2: listOfTweetsToPass = retweetedTweets
                case 3: listOfTweetsToPass = mentionsTweets
                case 4: listOfTweetsToPass = postsTweets
                default: break
                }
        performSegue(withIdentifier: "show List", sender: self)
    }
    
        @IBOutlet var followers: UILabel!
    
        @IBOutlet var retweets: UILabel!
    
        @IBOutlet var mentions: UILabel!

        @IBOutlet var posts: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view1.layer.cornerRadius = 10
        view2.layer.cornerRadius = 10
        view3.layer.cornerRadius = 10
        view4.layer.cornerRadius = 10
        
    }
    
    
    func saveObject(ids: [Int], entity: String, sender: String) {
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
    
        for item in ids {
        let user = NSEntityDescription.insertNewObject(forEntityName: entity, into: managedContext) as? TwitterUser
        let tweet = NSEntityDescription.insertNewObject(forEntityName: entity, into: managedContext) as? Tweet
        
            switch sender {
            case "getFollowers":
                user?.id = String(item)
                followerslist.append(user!)
                case "getRetweets":
                    tweet?.id = String(item)
                    retweetedTweets.append(tweet!)
                case "getMentions":
                    tweet?.id = String(item)
                    mentionsTweets.append(tweet!)
                case "getPosts":
                    tweet?.id = String(item)
                    postsTweets.append(tweet!)
            default: break
            }
        }
        do {
            try managedContext.save()
            //5
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
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



