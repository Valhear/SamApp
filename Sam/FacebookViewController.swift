//
//  FacebookViewController.swift
//  Sam
//
//  Created by Valentina Henao on 12/9/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FacebookViewController: UIViewController {

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
    
    @IBAction func composePost(_ sender: UIBarButtonItem) {
        composePost(sender: sender)
        
    }
    
    func composePost(sender: AnyObject) {
        //let composer = TWTRComposer()
        
       // composer.setText("SAM is so cool!")
        
        // Called from a UIViewController
       // composer.show(from: self) { result in
        //    if (result == TWTRComposerResult.cancelled) {
                print("This is to compose a facebook post")
          //  }
           // else {
             //   print("Sending tweet!")
           // }
        //}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize.height = 700
        scrollView.contentSize.width = 300
        self.tabBarController?.tabBar.isHidden = false
        
        menuSlideOut.action = #selector(SWRevealViewController.revealToggle(_:))
        
        newButton.addTarget(self, action: #selector(self.composePost(_:)), for: UIControlEvents.touchUpInside)
        
        //UI Configuration INIT
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
        //UI Configuration END
        
        
        
        
        //        if result != nil,
        //        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
        //            if connectionError != nil {
        //                print("Error: \(connectionError)")
        //            }
        //            if data != nil { do {
        //                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
        //                //     print("json: \(json)")
        //                if let x = json?["ids"] as? [Int?] {
        //                    ids.append(contentsOf: x)
        //                    if let cursor = json?["next_cursor"] as? Int {
        //
        //                        if cursor != 0 {
        //                            let params = ["count": "\(count)", "cursor": "\(cursor)"]
        //                            self.reqFollowers(params: params, ids: ids)
        //                        }
        
        
        //getPosts()
       // getFriends()
        getFeed()
    }
    
    func getFriends(){
        reqFriends()
    }
    
    func reqFriends(){
        
        
        //        if nextCursor != nil {
        //        params1["after"] = nextCursor
        //        }
            let params = ["fields": "uid, first_name, last_name, middle_name"] //first_name, last_name, middle_name
            let request = FBSDKGraphRequest(graphPath: "me/friends", parameters: params) //taggable_friends
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
    
                                //                            let data = y.object(forKey: "data") as! NSArray
                                //
                                //                            let first = data[0] as! NSDictionary
                                //                            let name = first.object(forKey: "first_name") as! String
                                //                            print(name)
                                //                            print("IMADEIT?")
                                //                            let paging = y.object(forKey: "paging") as! [String:Any]
                                //                            let nextCursor = paging["next"] as! String
                                //                            print(nextCursor)
                            }
                        }
                    }
                    
                }
            })
            connection.start()
    
    }
    
    func getFeed() { // NEED TO FILTER BY PUBLISHER
        let params = ["fields": "reactions.limit(0).fields(total_count).summary(true), from, created_time, status_type, description, message, link",  "limit": "5000"]
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
                    print("results tagged TAGS: \(result)")
                    do {
                        if JSONSerialization.isValidJSONObject(result!) {
                            if let y = result as? NSDictionary {
                                let data = y.object(forKey: "data") as! NSArray
                                if data.count > 0 {
                                    for i in 0..<data.count {
                                        let post = FbkPost()
                                        let item = data[i] as! NSDictionary
                                        if let from = item["from"] as? NSDictionary {
                                            let name = from["name"] as! String
                                                post.from = name
                                        }
                                        if let reactions = item["reactions"] as? NSDictionary {
                                            let summary = reactions.object(forKey: "summary") as? NSDictionary
                                            let totalReactions = summary?["total_count"] as! Int
                                            post.reactions = totalReactions
                                        }
                                        let created = item["created_time"] as? String
                                        let formatter = DateFormatter()
                                        let date = formatter.date(from: created!)
                                        post.created = date
                                        let message = item["message"] as? String
                                        post.message = message
                                        let link = item["link"] as? String
                                        post.link = link
                                        let descriptn = item["description"] as? String
                                        post.descriptn = descriptn
                                        let defaultType = item["status_type"] as? String
                                        post.status_type = defaultType
                                        postsArray.append(post)
                                    }
                                    print(postsArray.count)
                                }
                                print(data.count)
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
    
    func savePosts(postsArray: [FbkPost?]) {
        
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
