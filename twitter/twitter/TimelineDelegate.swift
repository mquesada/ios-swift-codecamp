//
//  TimelineDelegate.swift
//  twitter
//
//  Created by Maricel Quesada on 10/12/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

protocol TimelineDelegate {
    
    func addTweetToTimeline(tweet: Tweet)
    
    func updateTweetInTimeline(tweet: Tweet, index: Int)
}