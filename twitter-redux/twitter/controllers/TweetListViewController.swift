//
//  TweetListViewController.swift
//  twitter
//
//  Created by Maricel Quesada on 10/11/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit


class TweetListViewController: TweetsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadTimeline() {
        showLoadingSpinner()
        var params = Dictionary<String,String>()
        params["count"] = "\(tweetsCount)"
        TwitterClient.sharedInstance.homeTimelineWithParams(params, completion: { (tweets, error) -> () in
            if (error == nil) {
                self.tweets = tweets
                if (tweets.count > 0) {
                    self.lastStatusId = self.tweets.last!.id
                }
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                self.loading = false
            } else {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.refreshControl.endRefreshing()
                TSMessage.showNotificationWithTitle("Error loading timeline", type: TSMessageNotificationType.Error)
            }
        })
    }
    
    override func loadMoreTweets() {
        showLoadingSpinner()
        var params = Dictionary<String,String>()
        params["count"] = "\(tweetsCount)"
        if (self.lastStatusId != 0) {
            params["max_id"] = "\(self.lastStatusId)"
        }
        self.loading = true
        TwitterClient.sharedInstance.homeTimelineWithParams(params, completion: { (tweets, error) -> () in
            if (error == nil) {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.refreshControl.endRefreshing()
                for tweet in tweets {
                    var row = self.tweets.count
                    self.tweets.append(tweet)
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow:row, inSection:0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
                var lastTweet = self.tweets.last
                if (lastTweet != nil) {
                    self.lastStatusId = lastTweet!.id
                }
                self.loading = false
            } else {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.refreshControl.endRefreshing()
                TSMessage.showNotificationWithTitle("Error loading timeline", type: TSMessageNotificationType.Error)
            }
        })
    }    
    
}
