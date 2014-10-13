//
//  TwitterClient.swift
//  twitter
//
//  Created by Maricel Quesada on 10/11/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import Foundation

let consumerKey = "ZJoWaejBOlIduEpMiirwVuS1T"
let consumerSecret = "F8YSASPXw8Z82n3pGTfihhiiZVnExT5H8eGlxpXgX3tAicYa2P"
let twitterBaseUrl = "https://api.twitter.com"

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: NSURL(string: twitterBaseUrl), consumerKey: consumerKey, consumerSecret: consumerSecret)
        
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        if (User.currentUser != nil) {
            self.loginCompletion?(user: User.currentUser, error: nil)
        } else {
        
            self.requestSerializer.removeAccessToken()
            self.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "swifttwitterclient://oauth"), scope: nil,
                success: { (requestToken: BDBOAuthToken!) -> Void in
                    println("Got my request token")
                    var authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                    UIApplication.sharedApplication().openURL(authUrl)
                },
                failure: { (error: NSError!) -> Void in
                    println("Something happened \(error.description)")
                    self.loginCompletion?(user: nil, error: error)
                }
            )
        }
    }
        
    func openUrl(url: NSURL) {
        self.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query),
            success: { (accessToken: BDBOAuthToken!) -> Void in
                println("Got my access token")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                self.verifyCredentials()
                
            },
            failure: { (error: NSError!) -> Void in
                println("Failed to receive access token")
            }
        )
    }
    

    func verifyCredentials() {
        self.GET("1.1/account/verify_credentials.json", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(data: response as NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to get user \(error.description)")
                self.loginCompletion?(user: nil, error: error)
            }
        )
        
    }
    
    func homeTimelineWithParams(params: Dictionary<String, String>?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.GET("1.1/statuses/home_timeline.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to get timeline")
                completion(tweets: nil, error: error)
            }
        )
        
    }
    
    func postTweetWithCompletion(tweet: String, replyId: Int?, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        var params = ["status": tweet]
        if (replyId != nil) {
            params.updateValue("\(replyId!)", forKey: "in_reply_to_status_id")
        }
        self.POST("/1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(data: response as NSDictionary)
            completion(tweet: tweet, error: nil)
            
        }) { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
            completion(tweet: nil, error: error)
        }
    }
    
    func toggleFavoriteTweetWithCompletion(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        var params = ["id": tweet.id]
        
        var url = "/1.1/favorites/create.json"
        if (tweet.favorited) {
            url = "/1.1/favorites/destroy.json"
        }
        self.POST(url, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(data: response as NSDictionary)
            completion(tweet: tweet, error: nil)
            
            }) { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
                completion(tweet: nil, error: error)
        }
        
    }
    
    func retweetWithCompletion(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        var url = "/1.1/statuses/retweet/\(tweet.id).json"
        self.POST(url, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(data: response as NSDictionary)
            completion(tweet: tweet, error: nil)
            
            }) { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
                completion(tweet: nil, error: error)
        }
        
    }
    
}