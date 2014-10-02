//
//  YelpClient.swift
//  yelp
//
//  Created by Maricel Quesada on 9/30/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class YelpClient: BDBOAuth1RequestOperationManager {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey: String!, consumerSecret: String!, accessToken: String, accessSecret: String) {
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, parameters: Dictionary<String, String>? = nil, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
    
        var parameters = [
            "term": term, "location": "San Francisco"
        ]
    
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
   
}
