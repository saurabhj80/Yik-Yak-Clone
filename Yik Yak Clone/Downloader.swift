//
//  Downloader.swift
//  Yik Yak Clone
//
//  Created by Saurabh Jain on 5/31/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

let queryNotification = "queryUserFeedNotification"
let postNotification = "postNotification"
let queryCommentNotification = "queryCommentNotification"
let postCommentNotification = "postCommentNotification"

class Downloader: NSObject {
    
    // Singleton
    static let sharedDownloader = Downloader()
    
    // Queries and returns the posts based on the locations
    // of the user
    func queryForPosts() {
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) in
            
            if !(error != nil) {
                
                if let geoPoint = geopoint {
                    
                    let query = PFQuery(className: "UserFeed")
                    query.whereKey("location", nearGeoPoint: geoPoint, withinMiles: 5)
                    query.limit = 15
                    query.addDescendingOrder("createdAt")
                    
                    query.findObjectsInBackgroundWithBlock { (object, error) in
                        
                        if let object = object {
                            
                            let obj = object as! [PFObject]                            
                            // Post Notification
                            dispatch_async(dispatch_get_main_queue()) {
                                NSNotificationCenter.defaultCenter().postNotificationName(queryNotification, object: obj)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func queryForComments(object: PFObject) {
        
        
        let query = PFQuery(className: "Comments")
        query.whereKey("post", equalTo: object)
        
        query.findObjectsInBackgroundWithBlock { (object, error) -> Void in
            
            if let object = object {
                
                println(object)
                
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotificationName(queryCommentNotification, object: object)
                }
            }
            
        }
        
    }
    
    func postingAComment(text: String, post: PFObject) {
        
        let comment = PFObject(className: "Comments")
        comment.setValue(post, forKey: "post")
        comment.setValue(text, forKey: "text")
        comment.setValue(PFUser.currentUser(), forKey: "fromUser")
        
        comment.saveInBackgroundWithBlock { (success, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(postCommentNotification, object: success)
            })
            
        }
        
    }
    
    
    func postFeed(text: String) {
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) in
            
            if let geopoint = geopoint {
                
                let object = PFObject(className: "UserFeed")
                object.setValue(text, forKey: "post")
                object.setValue(geopoint, forKey: "location")
                
                if let user = PFUser.currentUser() {
                    object.setValue(user, forKey: "fromUser")
                }
                
                object.saveInBackgroundWithBlock({ (success, error) -> Void in
                    
                   dispatch_async(dispatch_get_main_queue()) {
                         NSNotificationCenter.defaultCenter().postNotificationName(postNotification, object: success)
                   }
                    
                })
            }
            
        }
        
    }
    
}
