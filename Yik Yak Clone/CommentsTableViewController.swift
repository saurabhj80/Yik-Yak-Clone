//
//  CommentsTableViewController.swift
//  Yik Yak Clone
//
//  Created by Saurabh Jain on 5/31/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController, CommentingViewControllerDelegate {

    // The post for which to find the comments
    var postObject: PFObject!
    
    // Array containing comments for the postObject
    private var myComments: [PFObject]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var header_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleComments:", name: queryCommentNotification, object: nil)
        
        
        // Query for comments
        Downloader.sharedDownloader.queryForComments(postObject)
        
        // Set Up the header view
        header_label = UILabel(frame: .zeroRect)
        header_label.text = postObject["post"] as? String
        header_label.sizeToFit()
        header_label.frame.origin = .zeroPoint
        header_label.textAlignment = .Center
        header_label.textColor = UIColor.redColor()
        header_label.font = UIFont(name: "HelveticaNeue-Medium", size: 22)
        
        tableView.tableHeaderView = header_label
        
        // Right Bar Button Item
        let barButtonItem = UIBarButtonItem(title: "Comments", style: .Done, target: self, action: "postComments")
        navigationItem.rightBarButtonItem = barButtonItem
        
    }
    
    // SEL for the bar button item
    func postComments() {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("commentingVC") as! CommentingViewController
        vc.postObject = self.postObject
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Commenting View Controller Delegate
    func pop() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func reloadComments() {
        pop()
        Downloader.sharedDownloader.queryForComments(postObject)
    }
    
    // notification SEL
    func handleComments(notification: NSNotification) {
        
        let comments = notification.object as? [PFObject]
        
        if let comments = comments {
            myComments = comments
        }
    }
}


// MARK: - Table view data source
extension CommentsTableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myComments?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UITableViewCell

        if let myComments = myComments {
            let comment = myComments[indexPath.row]
            cell.textLabel?.text = comment["text"] as? String
        }
        
        return cell
    }

}
