//
//  ProfileViewController.swift
//  twitter
//
//  Created by Maricel Quesada on 10/18/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class ProfileViewController: TweetsViewController {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        if (self.user == nil) {
            self.user = User.currentUser
        }
        
        super.viewDidLoad()
        self.setData()
    }
    
    override func viewWillAppear(animated: Bool) {
        var navBar = self.navigationController?.navigationBar
        navBar!.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar!.shadowImage = UIImage()
        navBar!.translucent = true
        navBar!.opaque = true
        navBar!.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        var navBar = self.navigationController?.navigationBar
        navBar!.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        navBar!.shadowImage = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData() {
        if (user.bannerImageUrl != nil) {
            self.bannerImageView.setImageWithURL(user.bannerImageUrl)
        } else {
            self.bannerImageView.backgroundColor = UIColor.grayColor()
        }
        self.profileImageView.setImageWithURL(user.profileImageUrl)
        self.profileImageView.layer.borderWidth = 3.0
        self.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.profileImageView.layer.cornerRadius = 10.0
        self.profileImageView.clipsToBounds = true
        self.view.bringSubviewToFront(self.profileImageView)
        
        self.nameLabel.text = user.name
        self.screenNameLabel.text = "@\(user.screenName)"
        self.tagLineLabel.text = user.tagLine
        self.locationLabel.text = user.location
        if (user.url != nil) {
            self.urlLabel.text = user.url
            self.urlLabel.hidden = false
        }
        self.followingCountLabel.text = "\(user.followingCount)"
        self.followersCountLabel.text = "\(user.followersCount)"
        self.tweetsCountLabel.text = "\(user.tweetsCount)"
    }
    
    override func loadTimeline() {
        showLoadingSpinner()
        var params = Dictionary<String,String>()
        params["count"] = "\(tweetsCount)"
        params["user_id"] = self.user.id
        TwitterClient.sharedInstance.usersTimelineWithParams(params, completion: { (tweets, error) -> () in
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
                TSMessage.showNotificationWithTitle("Error loading users timeline", type: TSMessageNotificationType.Error)
            }
        })
    }
    
    override func loadMoreTweets() {
        showLoadingSpinner()
        var params = Dictionary<String,String>()
        params["count"] = "\(tweetsCount)"
        params["user_id"] = self.user.id
        if (self.lastStatusId != 0) {
            params["max_id"] = "\(self.lastStatusId)"
        }
        self.loading = true
        TwitterClient.sharedInstance.usersTimelineWithParams(params, completion: { (tweets, error) -> () in
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
                TSMessage.showNotificationWithTitle("Error loading users timeline", type: TSMessageNotificationType.Error)
            }
        })
    }

}
