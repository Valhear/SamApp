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
    var followerslist = [NSManagedObject]()
    var retweetedTweets = [NSManagedObject]()
    var mentionsTweets = [NSManagedObject]()
    var postsTweets = [NSManagedObject]()
    
//        {
//        didSet {
//            
//            self.retweets.text = String(retweetedTweets.count)
//        }
//    }
    
    
    @IBOutlet var view1: UIView!
    
    @IBOutlet var view2: UIView!
    
    @IBOutlet var view3: UIView!
    
    @IBOutlet var view4: UIView!
    
    @IBAction func updateButton(_ sender: UIButton) {
    }
    
    @IBAction func getfollowers(_ sender: UIButton) {
       
//        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
//            let client = TWTRAPIClient(userID: userID)
//            // make requests with client
//            let statusesShowEndpoint = "https://api.twitter.com/1.1/followers/list.json"
//            let params = ["user_id": "\(userID)"]
//            var clientError : NSError?
//            
//            let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
//            
//            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
//                if connectionError != nil {
//                    print("Error: \(connectionError)")
//                }
//                
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
//                    print("json: \(json)")
//                    if let x = json["users"] as? NSArray {
//                        let follo = x.count
//                        self.followers.text = String(follo)
//                        let d = "MAMAMIACOMOSOYDEBOBA"
//                            self.saveName(name: d)
//                        
//                        print("followers === \(follo)")
//                    }
//                    
//                    //                    if let item = json[0] as Array {
//                    //                        }
//                    
//                } catch let jsonError as NSError {
//                    print("json error: \(jsonError.localizedDescription)")
//                }
//                
//            }
//        }
        
        
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            // make requests with client
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
//                        self.saveTweet(name: d)
                    }
                   
//                    if let item = json[0] as Array {
//                        }
                    
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
                
            }
        }
        
    }
    @IBAction func getRetweets(_ sender: UIButton) {
        
        var retweets = 0
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
                                print("retweets === \(retweets)")
                            }
                    }
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
                
            }
        }
    }
    
    @IBAction func getMentions(_ sender: UIButton) {
        
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            // make requests with client
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
//                    if let x = json["user_mentions"] as? NSArray {
//                        let mentions = x.count
//                        self.mentions.text = String(mentions)
                        print("mentions === \(json.count)")
//                    }
                    
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
                
            }
        }
    }

    @IBAction func getPosts(_ sender: UIButton) {
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
                    //                    if let x = json["user_mentions"] as? NSArray {
                    //                        let mentions = x.count
                    //                        self.mentions.text = String(mentions)
                    print("posts === \(json.count)")
                    //                    }
                    
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
    
    @IBAction func segue(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "show List", sender: self)
        print(sender.view?.tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show List" {
            if let nextvc = segue.destination as? ListOfItemsTableViewController {
                if let gr = sender as? UITapGestureRecognizer {
                nextvc.rootView = gr.view!
                print(gr.view?.tag)

                }
            }
        }
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
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func saveTweet(created: NSDate?, createdBy: String?, id: String?, text: String?, array: String) {
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let tweet = NSEntityDescription.insertNewObject(forEntityName: "Tweet", into: managedContext) as? Tweet {
            tweet.text = text
            tweet.created = created
            tweet.createdBy = createdBy
            
        do {
            try managedContext.save()
            //5
            switch array {
                case "retweetedTweets": retweetedTweets.append(tweet)
                case "mentionsTweets": mentionsTweets.append(tweet)
                case "postsTweets": postsTweets.append(tweet)
//            case "followerslist": followerslist.append(tweet)
                default: break
            }
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
               
        }
    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchFromCoreData() {
        //////////////////////////
        //FETCHING FROM CORE DATA
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let x = "dsfd"
        //2
        let fetchRequest: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            retweetedTweets = results as! [Tweet]
            print("SUCESSFULLY FETCHED \(x)")
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        /////////////////////////
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



