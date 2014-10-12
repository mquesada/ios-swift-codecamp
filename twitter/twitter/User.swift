//
//  User.swift
//  twitter
//
//  Created by Maricel Quesada on 10/11/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

var _currentUser: User?
var currentUserKey = "currentUser"
var userDidLoginNotification = "userDidLoginNotification"
var userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    
    var name: String!
    var screenName: String!
    var profileImageUrl: NSURL!
    var tagLine: String!
    var data: NSDictionary!
    
    init(data: NSDictionary) {
        self.data = data
        self.name = data["name"] as String
        self.screenName = data["screen_name"] as String
        self.profileImageUrl = NSURL(string: data["profile_image_url"] as String)
        self.tagLine = data["description"] as String
    }
    
    class var currentUser: User? {
        get {
            if (_currentUser == nil) {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if (data != nil) {
                    var dict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser  = User(data: dict)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if (_currentUser != nil) {
                var data = NSJSONSerialization.dataWithJSONObject(user!.data!, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)

            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: userDidLogoutNotification, object: nil))
    }
    
    class func loginWithCompletion(completion: () -> Void) {
        TwitterClient.sharedInstance.loginWithCompletion { (user, error) -> () in
            if (user != nil) {
                completion()
            } else {
                
            }
        }
    }
    
    
}