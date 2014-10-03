//
//  SearchManager.swift
//  
//
//  Created by Maricel Quesada on 10/2/14.
//
//

class SearchManager {

    let consumerKey = "bb0cSZQ5TjORqBXJdLYSWQ"
    let consumerSecret = "g4fCISJKin7M5rqjk2_VMEAhjXQ"
    let accessToken = "suComg6zANp1rCasqN8CdQLmeyWdN7TA"
    let accessSecret = "1n_x9wo20ZOLi9z1OOA1TNfQ-Ds"

    var result = [Business]()
    var client : YelpClient!
    
    init(){
        self.client = YelpClient(consumerKey: consumerKey, consumerSecret: consumerSecret, accessToken: accessToken, accessSecret: accessSecret)
    }
    
    func executeSearch(term: String, limit: Int! = 20, offset: Int! = 0, before:() -> Void, after:() -> Void, onSuccess:() -> Void, onFailure:() -> Void) {
        before()
        
        var parameters = [
            "offset": "\(offset)",
            "limit": "\(limit)"
        ]
        
        client.searchWithTerm(term, parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let businesses = (response["businesses"] as Array).map({
                    (data: NSDictionary) -> Business in
                    return Business(data: data)
                })
                
                self.result = businesses
                
                onSuccess()
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                onFailure()
            }
        )
        
        after()
        
    }
    
}