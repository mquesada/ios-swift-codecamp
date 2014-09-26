//
//  Movie.swift
//  rotten
//
//  Created by Maricel Quesada on 9/23/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

/* Class to represent a Movie */
class Movie {
    
    var title: String
    var synopsis: String
    var posterUrl: String
    var posterUrlOrig: String
    var year = 0
    var rating: String
    var criticsScore = 0
    var audienceScore = 0
    var posterImage: UIImage?
    
    
    init(data: NSDictionary) {
        title = data["title"] as String
        synopsis = data["synopsis"] as String
        var posters = data["posters"] as NSDictionary
        posterUrl = posters["thumbnail"] as String
        
        // Original image is not being returned by the API, so hacking it to get the HD image
        posterUrlOrig = posterUrl.stringByReplacingOccurrencesOfString("tmb", withString: "ori", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        year = data["year"] as Int
        rating = data["mpaa_rating"] as String
        
        var scores = data["ratings"] as NSDictionary
        criticsScore = scores["critics_score"] as Int
        audienceScore = scores["audience_score"] as Int
    }
   
}
