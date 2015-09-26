//
//  ComposeViewController.swift
//  Yik Yak Clone
//
//  Created by Saurabh Jain on 5/31/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

// Protocol
protocol ComposeViewControllerDelegate: class {
    func dismissComposeViewController(viewController: ComposeViewController)
    func reloadTableViewAfterPosting()
}

class ComposeViewController: UIViewController {
    
    // Has to be weak to prevent retain cycles
    weak var delegate: ComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "posted:", name: postNotification, object: nil)
    }

    // Notification SEL
    func posted(notification: NSNotification) {
        
        if let success = notification.object as? Bool {
            
            if success {
                // Dismiss
                delegate?.reloadTableViewAfterPosting()
            } else {
                
                let alert = UIAlertController(title: "Error", message: "Could not post", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
                
            }
            
        }
    }
    
    @IBOutlet weak var sj_composeTextView: UITextView!
    
    @IBAction func dismissViewController(sender: UIBarButtonItem) {
        delegate?.dismissComposeViewController(self)
    }
    
    
    @IBAction func sendPost(sender: UIBarButtonItem) {
        if sj_composeTextView.text.characters.count > 0 {
            Downloader.sharedDownloader.postFeed(sj_composeTextView.text)
        }
    }

}
