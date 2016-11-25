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
    
    @IBOutlet var menuSlideOut: UIBarButtonItem!
    
     var titleForList = String()
    static var userImage = UIImage()
    static var userName = String()
    
    @IBAction func composeTweet(_ sender: UIBarButtonItem) {
        
        let composer = TWTRComposer()
        
        composer.setText("SAM is so cool!")
            
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
    
    @IBOutlet var infoButton: UIButton!
    
    @IBAction func infoButtonAction(_ sender: UIButton) {
    }
  
    @IBOutlet var dashboardButton: UIButton!
    
    var followerslist = [TwitterUser]()
    var retweetedTweets = [Tweet]()
    var mentionsTweets = [Tweet]()
    var postsTweets = [Tweet]()
    
    
    @IBOutlet var updateButton: UIBarButtonItem!
    
    @IBOutlet var view1: UIView!
    @IBOutlet var view1under: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view4: UIView!
    
    @IBOutlet var subView1: UIView!
    @IBOutlet var subView2: UIView!
    @IBOutlet var subView3: UIView!
    @IBOutlet var subView4: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        view1.layer.cornerRadius = 5
        view1under.layer.cornerRadius = 5
        view2.backgroundColor = UIColor(red:0.99, green:0.62, blue:0.49, alpha:1.0)
        view3.backgroundColor = UIColor(red:0.99, green:0.62, blue:0.49, alpha:1.0)
        view1.backgroundColor = UIColor(red:0.36, green:0.85, blue:0.98, alpha:1.0)
        view4.backgroundColor = UIColor(red:0.36, green:0.85, blue:0.98, alpha:1.0)
        view2.layer.cornerRadius = 5
        view3.layer.cornerRadius = 5
        view4.layer.cornerRadius = 5
        dateSelector.tintColor = UIColor(red:0.36, green:0.85, blue:0.98, alpha:1.0)
        //  dateSelector.layer.borderColor = UIColor.lightGray.cgColor
        // dateSelector.layer.borderWidth = 1
        dateSelector.layer.cornerRadius = 0
        dateSelector.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: UIControlState.selected)
        // dashboardButton.setTitleColor(UIColor.lightGray, for: .normal)
        dashboardButton.setTitleColor(UIColor.darkGray, for: .selected)
        
        
        for subView in [subView1, subView2, subView3, subView4] {
            subView?.layer.borderWidth = 0.5
            subView?.layer.borderColor = UIColor(red:0.88, green:0.89, blue:0.88, alpha:1.0).cgColor
        }
        
        
        for view in [view1, view2, view3, view4] {
            let subView = UIView(frame: CGRect(x: (view?.bounds.origin.x)!+8, y: (view?.bounds.origin.y)!+84, width: (view?.bounds.size.width)!-16, height: 0.5))
            subView.backgroundColor = UIColor.white
            subView.alpha = 0.9
            view?.addSubview(subView)
        }
        
        if revealViewController() != nil {
        menuSlideOut.target = self.revealViewController()
            menuSlideOut.action = #selector(SWRevealViewController.revealToggle(_:))
       }
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        fetchInitialDataFromCoreData()
        updateButton(updateButton)
        
       
    }

    func fetchInitialDataFromCoreData() { //(<#T##[NSManagedObject]#>arrayOfIds: )
        //FETCHING FROM CORE DATA
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //2
        let fetchTweets: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        let fetchUsers: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        

        do {
            let results =
                try managedContext.fetch(fetchTweets)

            retweetedTweets = results.filter { $0.type == "retweets" }
            postsTweets = results.filter { $0.type == "posts" }
            mentionsTweets = results.filter { $0.type == "mentions" }
            
            mentions.text = "\(mentionsTweets.count)"
            retweets.text = "\(retweetedTweets.count)"
            posts.text = "\(postsTweets.count)"
            
            print("retweetedTweets.count==\(retweetedTweets.count)")
            print("postsTweets.count== \(postsTweets.count)")
            print("mentionsTweets.count== \(mentionsTweets.count)")
            
             print("fetchfromcore Data count of tweets\(results.count)")
            
        } catch let error as NSError {
            print("Could not fetch tweets\(error), \(error.userInfo)")
        }
        do {
            let results = try managedContext.fetch(fetchUsers)
            followerslist = results
            followers.text = "\(followerslist.count)"
            print("fetchfromcore Data count of followers\(results.count)")
        } catch let error as NSError {
            print("Could not fetch followers \(error)")
        }
    }

    @IBAction func updateButton(_ sender: Any) {
        
        dateSelector.selectedSegmentIndex = 3
        calcTime(sender: 3)
        getfollowers()
        getRetweets()
        getMentions()
        getPosts()
        
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let twitterClient = TWTRAPIClient(userID: userID)
            twitterClient.loadUser(withID: userID) { (user, error) -> Void in
                if user != nil {
                    let imageUrl = URL.init(string: (user?.profileImageLargeURL)!)
                    do { let data = try Data.init(contentsOf: (imageUrl)!)
                        TwitterViewController.userImage = UIImage.init(data: data)!
                        TwitterViewController.userName = (user?.name)!
                    } catch let error as NSError {
                        print("error loading data \(error.localizedDescription)")
                    }
                }
            }
        }
        
    }
    
    func calcTime(sender: Int) {
        
        view1.alpha = 0.5
        view1.isOpaque = false
        view1.isUserInteractionEnabled = false
        let date = Date()
        let calendar = NSCalendar.current
        var component = Calendar.Component.year
        var value = -1
        
        switch sender {
        case 2: component = Calendar.Component.year
            
        case 1: component = Calendar.Component.month
        case 0: component = Calendar.Component.day
        value = -7
        case 3: mentions.text = "\(mentionsTweets.count)"
        posts.text = "\(postsTweets.count)"
        print("postsTweets.count\(postsTweets.count)")
        let sumOfRetweets = retweetedTweets.map { $0.retweeted }.reduce(0, +)
        retweets.text = "\(sumOfRetweets)"
        print("retweetedTweets.count \(retweetedTweets.count)")
        view1.alpha = 1
        view1.isUserInteractionEnabled = true
        let allTimesString1 = NSMutableAttributedString(string: "100% from")
        allTimesString1.append(NSMutableAttributedString(string: " all times", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 10)]))
        footLabel1.attributedText = allTimesString1
        footLabel2.attributedText = allTimesString1
        footLabel3.attributedText = allTimesString1
        footLabel4.attributedText = allTimesString1
        default: break
        }
        
        if sender != 3 {
            
            let calculated = calendar.date(byAdding: component, value: value, to: date)!
            let calculatedSecond = calendar.date(byAdding: component, value: value*2, to: date)!
            let attributedString = NSMutableAttributedString(string: "\(component)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 10)])
            
            let mt = calcArrayWithTime(array: mentionsTweets, date: calculated)
            mentions.text = "\(Int(mt))"
            var mt2 =  calcArrayWithTime(array: mentionsTweets, date: calculatedSecond)
            mt2 = mt2 - mt
            //print("\(calcPercentage(int1: Double(mt), int2: Double(mt2)))")
            let pctmt = calcPercentage(int1: Double(mt), int2: Double(mt2))
            let xmt = evaluatePct(pct: pctmt)
            xmt.append(attributedString)
            footLabel3.attributedText = xmt
            // print("mt---\(mt)  mt2--- \(mt2)")
            
            let pt = calcArrayWithTime(array: postsTweets, date: calculated)
            posts.text = "\(Int(pt))"
            var pt2 = calcArrayWithTime(array: postsTweets, date: calculatedSecond)
            pt2 = pt2-pt
            let pctpt = calcPercentage(int1: Double(pt), int2: Double(pt2))
            let xpt = evaluatePct(pct: pctpt)
            xpt.append(attributedString)
            footLabel4.attributedText = xpt
            //print("pt---\(pt)  pt2--- \(pt2)")
            
            let rt = calcArrayWithTime(array: retweetedTweets, date: calculated)
            retweets.text = "\(Int(rt))"
            var rt2 = calcArrayWithTime(array: retweetedTweets, date: calculatedSecond)
            rt2 = rt2-rt
            let pctrt = calcPercentage(int1: Double(rt), int2: Double(rt2))
            let xrt = evaluatePct(pct: pctrt)
            xrt.append(attributedString)
            footLabel2.attributedText = xrt
            // print("rt---\(rt)  rt2--- \(rt2)")
        }
    }
    
    func getfollowers() {
        let ids = [Int?]()
        let params = ["count": "5000"]
        reqFollowers(params: params, ids: ids)
        
    }
    func reqFollowers(params: [String:String], ids: [Int?]) {
        var ids = ids
        let count = params["count"]
            if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
                let client = TWTRAPIClient(userID: userID)
                let statusesShowEndpoint = "https://api.twitter.com/1.1/followers/ids.json"
                var clientError : NSError?
                let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
                client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                    if connectionError != nil {
                        print("Error: \(connectionError)")
                    }
                    if data != nil { do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                   //     print("json: \(json)")
                        if let x = json?["ids"] as? [Int?] {
                            ids.append(contentsOf: x)
                            if let cursor = json?["next_cursor"] as? Int {
                                
                                if cursor != 0 {
                               let params = ["count": "\(count)", "cursor": "\(cursor)"]
                            self.reqFollowers(params: params, ids: ids)
                                }
                            }
                            
                        }
                    } catch let jsonError as NSError {
                        print("json error: \(jsonError.localizedDescription)")
                        }
                    }
                    if ids.count != 0 {
                        let follo = ids.count
                        print("idscoutnnotwk\(ids.count)")
                        self.followers.text = String(follo)
                        self.saveObject(objects: ids, entity: "TwitterUser", sender: "getFollowers")
                    }
                }
            }
    }
    
    func getRetweets() {
        let params = ["count": "\(100)"]
        let twts = [TWTRTweet?]()
        let retweets = 0
        reqRetweets(params: params, twts: twts, retweets: retweets)
    }
    
    func reqRetweets(params: [String:String], twts: [TWTRTweet?], retweets: Int) {
        var twts = twts
        var retweets = retweets
        let parCount = Int(params["count"]!)
        var batchCount = parCount
        var batch = [TWTRTweet?]() {
            didSet {
                if batch.count == batchCount {
                    let maxID = batch[batchCount!-1]?.tweetID //let maxID = batch.last!?.tweetID
                    twts.removeLast()
                    let params = ["count": "\(parCount)", "max_id": maxID!]
                    self.reqRetweets(params: params, twts: twts, retweets: retweets)
                }
            }
        }
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            // make requests with client
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/retweets_of_me.json"
            // let params = ["count": "\(100)", "include_entities": "false", "include_user_entities": "false"]
            var clientError : NSError?
            let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(connectionError)")
                }
                if data != nil { do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                    
                    if json.count > 1 {
                        batchCount = json.count
                    }
                    
                    for tweet in json {
                        let info = tweet as! [String: Any]
                        if let twt = TWTRTweet(jsonDictionary: info) {
                            
                            if let ret = Int(exactly: (twt.retweetCount)) {
                                retweets += ret
                            }
                            twts.append(twt)
                            batch.append(twt) }
                    }
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                    }      }
                
                if retweets != 0 {
                    self.saveObject(objects: twts, entity: "Tweet", sender: "getRetweets")
                    self.retweets.text = String(retweets)
                }
            }
        } }
    
    
 
    func getMentions() {
        
        let params = ["count": "\(200)"]
        let twts = [TWTRTweet?]()
        reqMentions(params: params, twts: twts)
    }
    
    func reqMentions(params: [String:String], twts: [TWTRTweet?]) {
        var twts = twts
        var params = params
        let parCount = Int(params["count"]!)
        var batchCount = parCount
        var batch = [TWTRTweet?]()
            {
            didSet {
                if batch.count == batchCount {

                    
                    if let last = batch.last! {
                        let maxID = last.tweetID
                   
                        let params = ["count": "\(parCount!)", "max_id": maxID]
                        self.reqMentions(params: params, twts: twts)
                        
                    }
                }
            }
        }

        
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            
            let client = TWTRAPIClient(userID: userID)
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/mentions_timeline.json"
            var clientError : NSError?
            let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(connectionError)")
                }
                if data != nil { do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray

                    if json.count > 1 {
                        batchCount = json.count
                    }
                    
                    for item in json {
                        let info = item as! [String:Any]
                        let twt = TWTRTweet(jsonDictionary: info)
                        batch.append(twt)
                        twts.append(twt)
                    }

                    
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                    }
                    
                    
                    
                }
                 if twts.count != 0 {
                self.mentions.text = String(twts.count)
                self.saveObject(objects: twts, entity: "Tweet", sender: "getMentions")
                 }
            }
        }
    }

    func getPosts() {
        let params = ["count": "\(200)"]
        let twts = [TWTRTweet?]()
        reqPosts(params: params, twts: twts)
    }
    
    func reqPosts(params: [String:String], twts: [TWTRTweet?]) {
        var twts = twts
        var params = params
        let count = Int(params["count"]!)
        var batchCount = count
        var batch = [TWTRTweet?]()
            {
            didSet {
                if batch.count == batchCount {
                    if let last = batch.last! {
                        let maxID = last.tweetID
                        twts.removeLast()

                        let params = ["count": "\(count!)", "max_id": maxID]
                        self.reqPosts(params: params, twts: twts)
                    }
                    
                }
            }
        }
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            // make requests with client
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        //    params["user_id"] = "\(userID)"
            var clientError : NSError?
            let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(connectionError)")
                }
                
                if data != nil { do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                    
                    if json.count > 1 {
                    batchCount = json.count
                    }
                    
                    for item in json {
                        let info = item as! [String:Any]
                        let twt = TWTRTweet(jsonDictionary: info)
                        twts.append(twt)
                        batch.append(twt)
                    }
                    
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
                    
                }
                if twts.count != 0 {
                self.posts.text = String(twts.count)
                self.saveObject(objects: twts, entity: "Tweet", sender: "getPosts")
                }
            }
        }
    }
    
    func saveObject(objects: [Any], entity: String, sender: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        var list = [Tweet]()
        
        
        switch sender {
            
        case "getFollowers":
            
            let fetchRequest: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
            do {
                let fetchedUsers = try managedContext.fetch(fetchRequest)
                let existingIds = fetchedUsers.map { Int($0.id!)! }
                
                for id in objects {
                    if existingIds.contains(id as! Int) == false {
                        let user = NSEntityDescription.insertNewObject(forEntityName: entity, into: managedContext) as? TwitterUser
                        user?.id = "\(id as! Int)"
                        user?.created = NSDate()
                        followerslist.append(user!)
                    }
                }
//                let fetchRequest: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
//                do {
//                    let fetchedUsers = try managedContext.fetch(fetchRequest)
//                for user in fetchedUsers {
//                    managedContext.delete(user)
//                }
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)")
            }
            
            
            
            
            
            
        case "getRetweets":
            let predicate = NSPredicate(format: "type == %@", "retweets" )
            let fetchRequest: NSFetchRequest<Tweet> = Tweet.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                let fetchedEntities = try managedContext.fetch(fetchRequest)
                
                for entity in fetchedEntities {
                    managedContext.delete(entity)
                }
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)")
            }
            
            for item in objects {
                let tweet = NSEntityDescription.insertNewObject(forEntityName: entity, into: managedContext) as? Tweet
                tweet?.id = (item as? TWTRTweet)?.tweetID
                tweet?.created = (item as? TWTRTweet)?.createdAt as NSDate?
                tweet?.type = "retweets"
                tweet?.retweeted = ((item as? TWTRTweet)?.retweetCount)!
                list.append(tweet!)
            }
            retweetedTweets = list
            
        case "getMentions":
            let predicate = NSPredicate(format: "type == %@", "mentions" )
            let fetchRequest: NSFetchRequest<Tweet> = Tweet.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                let fetchedEntities = try managedContext.fetch(fetchRequest)
                
                for entity in fetchedEntities {
                    managedContext.delete(entity)
                }
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)")
            }
            
            for item in objects {
                let tweet = NSEntityDescription.insertNewObject(forEntityName: entity, into: managedContext) as? Tweet
                
                tweet?.id = (item as? TWTRTweet)?.tweetID
                tweet?.created = (item as? TWTRTweet)?.createdAt as NSDate?
                tweet?.type = "mentions"
                list.append(tweet!)
            }
            mentionsTweets = list
        case "getPosts":
            let predicate = NSPredicate(format: "type == %@", "posts" )
            let fetchRequest: NSFetchRequest<Tweet> = Tweet.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                let fetchedEntities = try managedContext.fetch(fetchRequest)
                
                for entity in fetchedEntities {
                    managedContext.delete(entity)
                }
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)")
            }
            for item in objects {
                let tweet = NSEntityDescription.insertNewObject(forEntityName: entity, into: managedContext) as? Tweet
                
                tweet?.id = (item as? TWTRTweet)?.tweetID
                tweet?.created = (item as? TWTRTweet)?.createdAt as NSDate?
                tweet?.type = "posts"
                list.append(tweet!)
            }
            postsTweets = list
        default: break
        }
        do {
            try managedContext.save()
            //5
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    
    
    @IBOutlet var dateSelector: UISegmentedControl!

    @IBAction func dateSelection(_ sender: UISegmentedControl) {
        
        calcTime(sender: sender.selectedSegmentIndex)
    }

    
    
    func evaluatePct(pct: Int) -> NSMutableAttributedString {
        let totString = NSMutableAttributedString()
        if pct <= 0 {
        totString.append(NSMutableAttributedString(string: "\(pct)%", attributes: [NSForegroundColorAttributeName: UIColor.red]))
        } else {
        totString.append(NSMutableAttributedString(string: "+\(pct)%", attributes: [NSForegroundColorAttributeName: UIColor.green]))
        }
        totString.append(NSMutableAttributedString(string: " from previous "))
            return totString
    }
   
//    func getString() {
//    
//    let str = NSMutableAttributedString(string: "\(calcPercentage(int1: Double(pt), int2: Double(pt2)))", attributes: [NSForegroundColorAttributeName: UIColor.blue])
//    let str2 = NSMutableAttributedString(string: "% from previous")
//    let str3 = NSMutableAttributedString(string: "\(component)", attributes: [NSForegroundColorAttributeName: UIColor.blue])
//    
//    let tot = NSMutableAttributedString()
//    tot.append(str)
//    tot.append(str2)
//    tot.append(str3)
//    
//    footLabel4.attributedText = tot
//    //  footLabel4.attributedText = "\(str)% from previous \(component)"  ///calcPercentage(int1: Double(pt), int2: Double(pt2))
//    
//    }
    
    func calcArrayWithTime(array: [Tweet], date: Date) -> Double {
        var newIDs: [Tweet] = []
        for tw in array {
            let res = tw.created?.compare(date)
            if res == ComparisonResult.orderedDescending {
                newIDs.append(tw)
            }
        }
        return Double(newIDs.count)
    }
    
    func calcPercentage(int1: Double, int2: Double) -> Int {
        if int2 == 0 {
            if int1 == 0 {
            return 0
            }
            return 100
        }
        if int2 != int1 {
        let difc = int1-int2
           
            let pct = (difc/int2)*100
            return Int(pct)
        }
        return 0
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show List" {
            if let nextvc = segue.destination as? ListOfItemsTableViewController {
                nextvc.listOfIds = listOfIdsToPass
                nextvc.objectType = objectType
                nextvc.titleForList = titleForList

            }
        }
    }
    
    var listOfIdsToPass = [String]()
    var objectType = String()
    
    var listOfTweetsToPass = [AnyObject]() {
        didSet {
            if let ar = listOfTweetsToPass as? [Tweet] {
                var ids = [String]()
                for item in ar {
                    ids.append(item.id!)
                }
                listOfIdsToPass = ids
                objectType = "Tweets"
            } else if let ar = listOfTweetsToPass as? [TwitterUser] {
                var ids = [String]()
                for item in ar {
                    ids.append(item.id!)
                }
                listOfIdsToPass = ids
                objectType = "Users"
                }
            }
        
    }
    
    @IBAction func segue(_ sender: UITapGestureRecognizer) {
    
                switch (sender.view?.tag)! as Int {
                case 1: listOfTweetsToPass = followerslist
                    titleForList = "Followers"
                case 2: listOfTweetsToPass = retweetedTweets
                    titleForList = "Retweets"
                case 3: listOfTweetsToPass = mentionsTweets
                    titleForList = "Mentions"
                case 4: listOfTweetsToPass = postsTweets
                    titleForList = "Posts"
                default: break
                }
        performSegue(withIdentifier: "show List", sender: self)
    }

    
        @IBOutlet var followers: UILabel!
        @IBOutlet var retweets: UILabel!
        @IBOutlet var mentions: UILabel!
        @IBOutlet var posts: UILabel!
    
    @IBOutlet var footLabel1: UILabel!
    @IBOutlet var footLabel2: UILabel!
    @IBOutlet var footLabel3: UILabel!
    @IBOutlet var footLabel4: UILabel!
    
    
    
    

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



