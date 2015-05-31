//
//  UserFeedTableViewController.swift
//  Yik Yak Clone
//
//  Created by Saurabh Jain on 5/31/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class UserFeedTableViewController: UITableViewController, ComposeViewControllerDelegate {
    
    // Post Array
    // Containing the feed
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "queryFeeds:", name: queryNotification, object: nil)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // Notification SEL
    func queryFeeds(notification: NSNotification) {
        posts = notification.object as? [PFObject]
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "postSegue" {
            
            let nav = segue.destinationViewController as! UINavigationController
            let composeVc = nav.topViewController as! ComposeViewController
            composeVc.delegate = self
        }
        
        if segue.identifier == "commentsSegue" {
            
            let vc = segue.destinationViewController as! CommentsTableViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let object = posts![indexPath!.row]
            
            vc.postObject = object
            
        }
    }
    
    // Dismiss Compose VC
    func dismissComposeViewController(viewController: ComposeViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reloadTableViewAfterPosting() {
        dismissViewControllerAnimated(true, completion: nil)
        Downloader.sharedDownloader.queryForPosts()
    }
}


// MARK: - Table view data source
extension UserFeedTableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return posts?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        
        if let posts = posts {
            let object = posts[indexPath.row]
            cell.textLabel?.text = object["post"] as? String
            cell.textLabel?.numberOfLines = 0
        }
        
        return cell
    }
    
}
