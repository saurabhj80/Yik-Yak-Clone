//
//  CommentingViewController.swift
//  Yik Yak Clone
//
//  Created by Saurabh Jain on 5/31/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

protocol CommentingViewControllerDelegate: class {
    func pop()
    func reloadComments()
}

class CommentingViewController: UIViewController {

    // The post object
    var postObject: PFObject!
    
    // Delegate
    weak var delegate: CommentingViewControllerDelegate?
    
    // text view
    @IBOutlet weak var sj_commentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add Observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handlePostingComment:", name: postCommentNotification, object: nil)
        
        // Right bar button item
        let item = UIBarButtonItem(title: "Post", style: .Done, target: self, action: "postComment")
        navigationItem.rightBarButtonItem = item
        
    }
    
    // Post A comment
    func postComment() {
        if sj_commentTextView.text.characters.count > 0 {
            Downloader.sharedDownloader.postingAComment(sj_commentTextView.text, post: postObject)
        }
    }
    
    
    // Notification SEL
    func handlePostingComment(notification: NSNotification) {
        
        if let success = notification.object as? Bool {
            if success {
                delegate?.reloadComments()
            } else {
                // Set Alert
            }
        }
    }
    

}
