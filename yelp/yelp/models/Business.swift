//
//  Business.swift
//  
//
//  Created by Maricel Quesada on 10/1/14.
//
//

class Business {
    
    var name: String
    var profileImageUrl: NSURL
    var rating: Int
    var ratingImageUrl: NSURL
    var reviewCount: Int
    var location: NSDictionary?
    var categoryList: Array<Array<String>>?
    var region: NSDictionary?
    
    init(data: NSDictionary) {
        self.name = data["name"] as String
        self.profileImageUrl = NSURL(string: data["image_url"] as String)
        self.rating = data["rating"] as Int
        self.ratingImageUrl = NSURL(string: data["rating_img_url"] as String)
        self.reviewCount = data["review_count"] as Int
        self.location = data["location"] as? NSDictionary
        self.categoryList = data["categories"] as? Array<Array<String>>
        self.region = data["region"] as? NSDictionary
    }
    
    var address: String {
        get {
            if let location = self.location {
                if let address = location["display_address"] as? Array<String> {
                    return ", ".join(address)
                }
            }
            return ""
        }
    }
    
    var latitude: Double {
        get {
            if let region = self.region {
                if let center = region["center"] as? NSDictionary {
                    return center["latitude"] as Double
                }
            }
            return 0.0
        }
    }
    
    var longitude: Double {
        get {
            if let region = self.region {
                if let center = region["center"] as? NSDictionary {
                    return center["longitude"] as Double
                }
            }
            return 0.0
        }
    }
    
    var categories: String {
        get {
            if let cats = self.categoryList {
                return ", ".join(cats.map({ $0[0] }))
            }
            return ""
        }
    }
    
   
}
