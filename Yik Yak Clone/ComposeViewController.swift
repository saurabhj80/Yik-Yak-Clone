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
    
    // Delegate
    weak var delegate: ComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "posted:", name: postNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
        if count(sj_composeTextView.text) > 0 {
            Downloader.sharedDownloader.postFeed(sj_composeTextView.text)
        }
    }

}
