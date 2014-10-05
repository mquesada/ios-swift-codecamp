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
    var filterManager = FilterManager()
    var location: String!
    
    init(){
        self.client = YelpClient(consumerKey: consumerKey, consumerSecret: consumerSecret, accessToken: accessToken, accessSecret: accessSecret)
    }
    
    func executeSearch(term: String, limit: Int! = 20, offset: Int! = 0, before:() -> Void, after:() -> Void, onSuccess:() -> Void, onFailure:() -> Void) {
        before()
        
        var parameters = self.filterManager.getSelectedCategories()
        parameters["offset"] = "\(offset)"
        parameters["limit"] = "\(limit)"
        
        if (location != nil) {
            parameters["location"] = location
        } else {
            parameters["location"] = "San Francisco,CA"
        }
        
        client.searchWithTerm(term, filters: parameters,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let businesses = (response["businesses"] as Array).map({
                    (data: NSDictionary) -> Business in
                    return Business(data: data)
                })
                
                self.result = businesses
                
                onSuccess()
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error.description)
                onFailure()
            }
        )
        
        after()
        
    }
    
}