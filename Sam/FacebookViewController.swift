//
//  FacebookViewController.swift
//  Sam
//
//  Created by Valentina Henao on 12/9/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import CoreData

class FacebookViewController: UIViewController {

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let myDefaults = UserDefaults.standard
    
    static var userImage = UIImage()
    static var userName = String()

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var menuSlideOut: UIBarButtonItem!
    @IBOutlet var lastUpdatedLabel: UILabel!
    @IBOutlet var newButton: UIButton!
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
    @IBOutlet var dateSelector: UISegmentedControl!
    @IBOutlet var friends: UILabel!
    @IBOutlet var reactions: UILabel!
    @IBOutlet var postsByOthers: UILabel!
    @IBOutlet var postsByMe: UILabel!
    @IBOutlet var footLabel1: UILabel!
    @IBOutlet var footLabel2: UILabel!
    @IBOutlet var footLabel3: UILabel!
    @IBOutlet var footLabel4: UILabel!
    @IBOutlet var dashboardButton: UIButton!

    @IBOutlet var superView: UIView!
    
    @IBAction func dateSelection(_ sender: UISegmentedControl) {
        
        calcTime(sender: sender.selectedSegmentIndex)
    }
    
    @IBAction func segue(_ sender: UITapGestureRecognizer) {
        
        switch (sender.view?.tag)! as Int {
        case 1: listOfItemsToPass = []
        titleForList = "Friends"
        case 2: listOfItemsToPass = reactionsList
        titleForList = "Reactions"
        case 3: listOfItemsToPass = postsByOthersList
        titleForList = "Posts By Others"
        case 4: listOfItemsToPass = postsByMeList
        titleForList = "Posts By Me"
        default: break
        }
        performSegue(withIdentifier: "show Posts", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show Posts" {
            if let nextvc = segue.destination as? ListOfFbkPostsTableViewController {
                nextvc.listOfPosts = listOfItemsToPass
                nextvc.titleForList = titleForList
                
            }
        }
    }
    
    
    var listOfItemsToPass = [FbkPostObj]()
    var titleForList = String()
    
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
            case 3: reactions.text = "\(reactionsList.map{ $0.reactions }.reduce(0,+))"
            postsByMe.text = "\(postsByMeList.count)"
            postsByOthers.text = "\(postsByOthersList.count)"
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
            // Posts By Me calculations
            let pm = calcArrayWithTime(array: postsByMeList, date: calculated).count
            postsByMe.text = "\(Int(pm))"
            var pm2 =  calcArrayWithTime(array: postsByMeList, date: calculatedSecond).count
            pm2 = pm2 - pm
            let pctpm = calcPercentage(int1: Double(pm), int2: Double(pm2))
            let xpm = evaluatePct(pct: pctpm)
            xpm.append(attributedString)
            footLabel3.attributedText = xpm
            // Posts By Others calculations
            let po = calcArrayWithTime(array: postsByOthersList, date: calculated).count
            postsByOthers.text = "\(Int(po))"
            var po2 = calcArrayWithTime(array: postsByOthersList, date: calculatedSecond).count
            po2 = po2-po
            let pctpo = calcPercentage(int1: Double(po), int2: Double(po2))
            let xpo = evaluatePct(pct: pctpo)
            xpo.append(attributedString)
            footLabel4.attributedText = xpo
            // Reactions calculations
            let rp = calcArrayWithTime(array: reactionsList, date: calculated)
            let sumOfReactions = rp.map{ $0.reactions }.reduce(0,+)
            reactions.text = "\(sumOfReactions)"
            let rp2 = calcArrayWithTime(array: reactionsList, date: calculatedSecond)
            var sumOfReactions2 = rp2.map{ $0.reactions }.reduce(0,+)
            sumOfReactions2 = sumOfReactions2-sumOfReactions
            let pctrp = calcPercentage(int1: Double(sumOfReactions), int2: Double(sumOfReactions2))
            let xrp = evaluatePct(pct: pctrp)
            xrp.append(attributedString)
            footLabel2.attributedText = xrp
        }
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
    
    func calcArrayWithTime(array: [FbkPostObj], date: Date) -> [FbkPostObj] {
        var newIDs: [FbkPostObj] = []
        for post in array {
            let res = post.created?.compare(date)
            if res == ComparisonResult.orderedDescending {
                newIDs.append(post)
            }
        }
        return newIDs
    }
    
    @IBAction func composePost(_ sender: UIBarButtonItem) {
        composePost(sender: sender)
    }
    
    func composePost(sender: AnyObject) {
        print("Pending feature: add new facebook post")
 
    }
    
    //List of posts to send to next VC
    var listOfPosts = [FbkPostObj]() {
        didSet {
            if let name = myDefaults.string(forKey: "Profilename") {
            postsByMeList = listOfPosts.filter { $0.from == "\(name)" }
            postsByMeList.sort(by: { $0.created?.compare($1.created as! Date) == .orderedDescending })
            postsByOthersList = listOfPosts.filter { $0.from != "\(name)" }
            postsByOthersList.sort(by: { $0.created?.compare($1.created as! Date) == .orderedDescending })
            
            }
            reactionsList = listOfPosts.filter { $0.reactions != 0 }
            reactionsList.sort(by: { $0.created?.compare($1.created as! Date) == .orderedDescending })
            postsByMe.text = "\(postsByMeList.count)"
            postsByOthers.text = "\(postsByOthersList.count)"
           
        }
    }
    var reactionsList = [FbkPostObj]() {
        didSet {
            let sumOfReactions = reactionsList.map{ $0.reactions }.reduce(0,+)
            reactions.text = "\(sumOfReactions)"

        }
    }
    var postsByMeList = [FbkPostObj]()
    var postsByOthersList = [FbkPostObj]()
    
    override func viewDidAppear(_ animated: Bool) {
        appDelegate.selectedTab = tabBarController?.selectedIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        newButton.isHidden = true
        
        let minHeight: CGFloat = 700

        if UIScreen.main.bounds.size.height > minHeight  {
            scrollView.contentSize.height = UIScreen.main.bounds.size.height
        } else {
            scrollView.contentSize.height = minHeight
        }
        
        
        scrollView.contentSize.width = 300
        
        self.tabBarController?.tabBar.isHidden = false
        menuSlideOut.action = #selector(SWRevealViewController.revealToggle(_:))
        
        if revealViewController() != nil {
            print("index \(tabBarController?.selectedIndex)")
            menuSlideOut.target = self.revealViewController()
            menuSlideOut.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        
        newButton.addTarget(self, action: #selector(self.composePost(_:)), for: UIControlEvents.touchUpInside)
        
        //UI Configuration
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
        dateSelector.layer.cornerRadius = 0
        dateSelector.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: UIControlState.selected)
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
        
        reqFriends()
        getFeed()
        if myDefaults.integer(forKey: "totalFriends") == nil {
            
            self.myDefaults.set(0, forKey: "totalFriends")
        }
        friends.text = "\(myDefaults.integer(forKey: "totalFriends"))"
        fetchInitialDataFromCoreData()
        updateButton(updateButton)
    }
    
    @IBAction func updateButton(_ sender: Any) {
   
        dateSelector.selectedSegmentIndex = 3
        calcTime(sender: 3)
        getProfile()
        reqFriends()
        getFeed()
     
    }
    
    func reqFriends(){
        
            let params = ["fields": "uid, first_name, last_name, middle_name"]
            let request = FBSDKGraphRequest(graphPath: "me/friends", parameters: params)
            let connection = FBSDKGraphRequestConnection()
            connection.add(request, completionHandler: { (connection, result, error) -> Void in
                if ((error) != nil)
                {
                    // Process error
                    print("Error: \(error)")
                }
                else if result != nil {
                    do {
                        if JSONSerialization.isValidJSONObject(result!) {
                            if let y = result as? NSDictionary {
                                let summary = y.object(forKey: "summary") as! NSDictionary
                                if let totalFriends = summary.object(forKey: "total_count") as? Int {
                                    if totalFriends > 0 {
                                        self.friends.text = String(totalFriends)
                                self.myDefaults.set(totalFriends, forKey: "totalFriends")
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                }
            })
            connection.start()
    
    }
    
    func getFeed() { // NEED TO FILTER BY PUBLISHER
        let params = ["fields": "reactions.limit(0).fields(total_count).summary(true), from.fields(picture,name), created_time, status_type, description, message, link, full_picture",  "limit": "5000"]
        let path = "me/feed"
        reqFeed(path: path, params: params, postsArray: [])
    }
    
    func reqFeed(path: String, params: [String:String]?, postsArray: [FbkPost?]){
            var postsArray = postsArray
            let request = FBSDKGraphRequest(graphPath: path, parameters: params)
            let connection = FBSDKGraphRequestConnection()
            connection.add(request, completionHandler: { (connection, result, error) -> Void in
                if ((error) != nil)
                { print("Error: \(error)") }
                else if result != nil {
                    do {
                        if JSONSerialization.isValidJSONObject(result!) {
                            if let y = result as? NSDictionary {
                                let data = y.object(forKey: "data") as! NSArray
                                if data.count > 0 {
                                    for i in 0..<data.count {
                                        let post = FbkPost()
                                        let item = data[i] as! NSDictionary
                                        if let from = item["from"] as? NSDictionary {
                                            let name = from["name"] as? String
                                                post.from = name
                                            if self.myDefaults.string(forKey: "Profilename") != name {
                                            let picture = from["picture"] as? NSDictionary
                                            
                                            if let data = picture?.object(forKey: "data") as? NSDictionary {
                                                
                                            let picURL = data["url"] as? String
                                                post.usrImageLink = picURL
                                
                                                }
                                            }
                                        }
                                        if let reactions = item["reactions"] as? NSDictionary {
                                            let summary = reactions.object(forKey: "summary") as? NSDictionary
                                            let totalReactions = summary?["total_count"] as! Int64
                                            post.reactions = totalReactions
                                        }
                                        if let created = item["created_time"] as? String {
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                                            let date = formatter.date(from: created)
                                        post.created = date
                                        }
                                        let message = item["message"] as? String
                                        post.message = message
                                        let picture = item["full_picture"] as? String
                                        post.imageLink = picture
                                        let link = item["link"] as? String
                                        post.link = link
                                        let descriptn = item["description"] as? String
                                        post.descriptn = descriptn
                                        let defaultType = item["status_type"] as? String
                                        post.status_type = defaultType
                                        postsArray.append(post)
                                    }
                                }
                                if let paging = y.object(forKey: "paging") as? [String:Any] {
                                    if let next = paging["next"] as? String {
                                    let nextFields = next.components(separatedBy: "?")[1]
                                        let str = "\(path)?".appending(nextFields)
                                    self.reqFeed(path: str, params: nil, postsArray: postsArray)
                                    }
                                }
                            }
                        }
                    }
                }
            })
            connection.start()
        if postsArray.count != 0 {
            self.savePosts(postsArray: postsArray)
        }
    }
    
    func getProfile() {
        FBSDKProfile.loadCurrentProfile(completion: { (profile, error) -> Void in
            self.myDefaults.set(profile?.name, forKey: "Profilename")
            self.myDefaults.set(profile?.imageURL(for: .normal, size: CGSize(width: 60.0, height: 60.0)), forKey: "imageUrl")
            
            let imageURL = profile?.imageURL(for: .normal, size: CGSize(width: 120.0, height: 120.0))
            do { let data = try Data.init(contentsOf: imageURL!)
                if let image = UIImage.init(data: data) {
                    FacebookViewController.userImage = image
                    FacebookViewController.userName = (profile?.name)!
                }
            } catch let error as NSError {
                print("error loading image data \(error.localizedDescription)")
                
            }
           
        } )
    }
    
    func savePosts(postsArray: [FbkPost?]) {
        var list = [FbkPostObj]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FbkPostObj> = FbkPostObj.fetchRequest()
        
        do {
        let fetchedPosts = try managedContext.fetch(fetchRequest)
            for post in fetchedPosts {
            managedContext.delete(post)
            }
        } catch let error as NSError {
            print("Could not delete posts\(error), \(error.userInfo)")
        }
        
        for item in postsArray {
            let post = NSEntityDescription.insertNewObject(forEntityName: "FbkPostObj", into: managedContext) as? FbkPostObj
            post?.created = (item! as FbkPost).created as NSDate?
            post?.from = item?.from
            post?.reactions = item?.reactions ?? 0
            post?.message = item?.message
            post?.link = item?.link
            post?.descriptn = item?.descriptn
            post?.imageLink = item?.imageLink
            post?.profileImage = item?.usrImageLink
            
            list.append(post!)
        }
        listOfPosts = list
        do {
            try managedContext.save()
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .medium
            
            lastUpdatedLabel.text = "Last Updated: \(dateFormatter.string(from: date))"
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
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
    
    func fetchInitialDataFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //2
        let fetchPosts: NSFetchRequest<FbkPostObj> = FbkPostObj.fetchRequest()
        
        do {
            let results =
                try managedContext.fetch(fetchPosts)
            
            listOfPosts = results

            
        } catch let error as NSError {
            print("Could not fetch tweets\(error), \(error.userInfo)")
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



