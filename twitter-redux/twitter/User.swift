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
    
    var id: String!
    var name: String!
    var screenName: String!
    var profileImageUrl: NSURL!
    var bannerImageUrl: NSURL!
    var tagLine: String!
    var followersCount: Int!
    var followingCount: Int!
    var tweetsCount: Int!
    var location: String!
    var url: String!
    var createdAt: NSDate!
    var createdAtString: String!
    var data: NSDictionary!
    
    init(data: NSDictionary) {
        self.data = data
        self.id = data["id_str"] as String
        self.name = data["name"] as String
        self.screenName = data["screen_name"] as String
        
        var profileUrl = (data["profile_image_url"] as String).stringByReplacingOccurrencesOfString("normal", withString: "bigger", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.profileImageUrl = NSURL(string: profileUrl)

        if let bannerUrl = data["profile_banner_url"] as? String {
            self.bannerImageUrl = NSURL(string: bannerUrl)
        }
        self.tagLine = data["description"] as String
        self.followersCount = data["followers_count"] as Int
        self.followingCount = data["friends_count"] as Int
        self.tweetsCount = data["statuses_count"] as Int
        self.location = data["location"] as String
        if let url = data["url"] as? String {
            self.url = url
        }
        
        self.createdAtString = data["created_at"] as String!
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        self.createdAt = formatter.dateFromString(self.createdAtString)!
        
        formatter.dateFormat = "MMM d hh:mm a"
        self.createdAtString = formatter.stringFromDate(self.createdAt)
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
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: userDidLoginNotification, object: nil))
                completion()
            } else {
                
            }
        }
    }
    
    class func isLoggedIn() -> Bool {
        return (currentUser != nil)
    }
    
    
}