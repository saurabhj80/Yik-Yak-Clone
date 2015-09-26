//
//  AppDelegate.swift
//  Yik Yak Clone
//
//  Created by Saurabh Jain on 5/30/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Application Key
    private let appKey = "GdwpdlaXUxsEz7hJZMwbp91o27b52hVs5TJOwT65"
    // Client Key
    private let clientKey = "dOX61T3CvprmKDbw4yBOCHWD2J5dAsEkY6rkcw8v"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Imp
        Parse.setApplicationId(appKey, clientKey: clientKey)
        
        // Log in Anonymously
        if !(PFUser.currentUser() != nil) {
            PFAnonymousUtils.logInWithBlock { (user, error) in
                print(user)
            }
        }
        
        return true
    }
}

