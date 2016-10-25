//
//  ListOfItemsTableViewController.swift
//  BlissApp
//
//  Created by Valentina Henao on 10/19/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import TwitterKit

class ListOfItemsTableViewController: UITableViewController {
    
    var listOfObject = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        

   //     let tweets = TWTRTweet.tweets(withJSONArray: array)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
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
        
        
        return listOfObject.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        let client = TWTRAPIClient()
        if let ar = listOfObject as? [Tweet] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath) as? TWTRTweetTableViewCell
            client.loadTweet(withID: "\(ar[indexPath.row].id!)") { tweet, error in
                if let t = tweet {
                    print(" \(t)")
                    cell?.tweetView.configure(with: t)

                } else {
                    print("Failed to load Tweet: \(error?.localizedDescription)")
                }
            }
            
            return cell!
        } else if let ar = listOfObject as? [TwitterUser] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath) as? ListTableViewCell
            client.loadUser(withID: "\(ar[indexPath.row].id!)") { user, error in
                if let u = user {
                    print("UUU \(u)")
                    let url = NSURL.init(string: u.profileImageURL)
                    let data = NSData.init(contentsOf: (url as? URL)!)
                    cell?.cellImage.image = UIImage.init(data: data as! Data)
                    cell?.nameLabel.text = u.name
                    cell?.ScreenNameLabel.text = u.screenName
                    
                } else {
                    print("Failed to load User: \(error?.localizedDescription)")
                }
                
        
            }
     return cell!
        }
    return (tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath) as? ListTableViewCell)!
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 69
//        return TWTRTweetTableViewCell.height(for: t, style: .compact, width: self.view.bounds.width, showingActions: true)
        
    }
    
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
    
//    func fetchFromCoreData(arrayOfIds: [NSManagedObject]) -> [Tweet]? {
//        //////////////////////////
//        //FETCHING FROM CORE DATA
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        //2
//        let fetchRequest: NSFetchRequest<Tweet> = Tweet.fetchRequest()
//        //        fetchRequest.predicate = NSPredicate(block: <#T##(Any?, [String : Any]?) -> Bool#>)
//        //3
//        do {
//            let results =
//                try managedContext.fetch(fetchRequest)
//            retweetedTweets = results
//            print(results)
//            
//            return results as! [Tweet]
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//        return nil
//        /////////////////////////
//    }
