//
//  UserFeedTableViewController.swift
//  Yik Yak Clone
//
//  Created by Saurabh Jain on 5/31/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class UserFeedTableViewController: UITableViewController {
    
    private var posts: [PFObject]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Query for feeds
        Downloader.sharedDownloader.queryForPosts()
        
        // Add observers
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "queryFeeds:", name: "queryUserFeedNotification", object: nil)
    }
    
    // Notification SEL
    func queryFeeds(notification: NSNotification) {
        posts = notification.object as? [PFObject]
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let posts = posts {
            return posts.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = "Hello Parse"
        
        return cell
    }
    

}
