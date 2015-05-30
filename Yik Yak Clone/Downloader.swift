//
//  Downloader.swift
//  Yik Yak Clone
//
//  Created by Saurabh Jain on 5/31/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

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
                    
                    query.findObjectsInBackgroundWithBlock { (object, error) in
                        
                        if let object = object {
                            
                            let obj = object as! [PFObject]
                            println(obj)
                            
                            // Post Notification
                            NSNotificationCenter.defaultCenter().postNotificationName("queryUserFeedNotification", object: obj)
                        }
                    }
                }
            }
        }
    }
}
