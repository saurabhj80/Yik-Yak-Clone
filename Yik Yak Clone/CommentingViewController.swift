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

    var postObject: PFObject!
    
    
    weak var delegate: CommentingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handlePostingComment:", name: postCommentNotification, object: nil)
        
        let item = UIBarButtonItem(title: "Post", style: .Done, target: self, action: "postComment")
        navigationItem.rightBarButtonItem = item
        
    }
    
    // Post A comment
    func postComment() {
        
        if count(sj_commentTextView.text) > 0 {
            Downloader.sharedDownloader.postingAComment(sj_commentTextView.text, post: postObject)
        }
        
    }
    
    
    func handlePostingComment(notification: NSNotification) {
        
        if let success = notification.object as? Bool {
            
            if success {
                
                delegate?.reloadComments()
                
                
            } else {
                
                
                
            }
            
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var sj_commentTextView: UITextView!

}
