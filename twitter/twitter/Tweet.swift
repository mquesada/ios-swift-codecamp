//
//  Tweet.swift
//  twitter
//
//  Created by Maricel Quesada on 10/11/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var id: Int
    var user: User
    var text: String
    var createdAt: NSDate
    var createdAtString: String
    var favoritesCount: Int
    var favorited: Bool
    var retweetCount: Int
    var retweeted: Bool
    
    init(data: NSDictionary) {
        self.id = data["id"] as Int!
        self.user = User(data: data["user"] as NSDictionary)
        self.text = data["text"] as String!
        self.createdAtString = data["created_at"] as String!
        self.favoritesCount = data["favorite_count"] as Int!
        self.favorited = data["favorited"] as Bool
        self.retweetCount = data["retweet_count"] as Int!
        self.retweeted = data["retweeted"] as Bool
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        self.createdAt = formatter.dateFromString(self.createdAtString)!
        
        formatter.dateFormat = "MMM d hh:mm a"
        self.createdAtString = formatter.stringFromDate(self.createdAt)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for data in array {
            tweets.append(Tweet(data: data))
        }
        return tweets
    }
    
   
}
