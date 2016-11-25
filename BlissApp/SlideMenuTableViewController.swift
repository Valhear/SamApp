//
//  SlideMenuTableViewController.swift
//  BlissApp
//
//  Created by Valentina Henao on 11/9/16.
//  Copyright © 2016 Valentina Henao. All rights reserved.
//

import UIKit
import TwitterKit
import Fabric

class SlideMenuTableViewController: UITableViewController {
    
    let exampleTransitionDelegate = TransitioningDelegate()
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        print("userName UserName \(TwitterViewController.userName)")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        logout()
        
       
    }
    
    func logout() {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "floatingViewController")
        controller?.transitioningDelegate = exampleTransitionDelegate
        controller?.modalPresentationStyle = .custom
        present(controller!, animated: true, completion: nil)
        
        

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as? HeaderTableViewCell
        
        header?.imageHeader.image = TwitterViewController.userImage
        header?.userHeader.text = TwitterViewController.userName
        
                return header

        
    }
   
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 200.0
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
