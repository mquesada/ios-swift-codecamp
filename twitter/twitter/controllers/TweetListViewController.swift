//
//  TweetListViewController.swift
//  twitter
//
//  Created by Maricel Quesada on 10/11/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit



class TweetListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TimelineDelegate {

    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    var refreshControl: UIRefreshControl!
    var tweets = [Tweet]()
    let tweetsCount = 50
    var lastStatusId: Int = 0
    var loading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        TSMessage.setDefaultViewController(self)
        
        setRefreshControl()
        
        homeTimeline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func homeTimeline() {
        showLoadingSpinner()
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if (error == nil) {
                self.tweets = tweets!
                var lastTweet = self.tweets.last
                if (lastTweet != nil) {
                    self.lastStatusId = lastTweet!.id
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
    
    func loadMoreTweets() {
        showLoadingSpinner()
        var params = Dictionary<String,String>()
        params["count"] = "\(tweetsCount)"
        if (self.lastStatusId != 0) {
            params["status_id"] = "\(lastStatusId)"
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
    
    
    func updateTimeline(tweet: Tweet) {
        self.tweets.insert(tweet, atIndex: 0)
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        cell.frame = CGRectMake(0, 0, 9999, 9999)
        cell.tweet = self.tweets[indexPath.row]
        cell.index = indexPath.row
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row + 5 >= self.tweets.count && !self.loading) {
            loadMoreTweets()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tweetDetailsSegue") {
            var detailsController = segue.destinationViewController as TweetDetailsViewController
            var cell = sender as TweetCell
            detailsController.tweet = cell.tweet
        } else if (segue.identifier == "tweetSegue") {
            var detailsController = segue.destinationViewController as TweetViewController
            detailsController.timelineDelegate = self
        } else if (segue.identifier == "replyTweetFromList") {
            var detailsController = segue.destinationViewController as TweetViewController
            var btn = sender as UIButton
            var tweet = self.tweets[btn.tag]
            detailsController.tweetReplyId = tweet.id
            detailsController.tweetReplyUsername = tweet.user.screenName
            detailsController.timelineDelegate = self
        }
    }

    @IBAction func logoutAction(sender: AnyObject) {
        User.currentUser?.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func addTweet(sender: AnyObject) {
        self.performSegueWithIdentifier("tweetSegue", sender: self)
    }
    
    @IBAction func retweetAction(sender: AnyObject) {
        var btn = sender as UIButton
        var tweet = self.tweets[btn.tag]
        if (!tweet.retweeted) {
            TwitterClient.sharedInstance.retweetWithCompletion(tweet, completion: { (tweet, error) -> Void in
                if (tweet != nil) {
                    self.tweets[btn.tag].retweeted = tweet.retweeted
                    btn.selected = tweet.retweeted
                } else {
                    TSMessage.showNotificationWithTitle("Error while retweeting", type: TSMessageNotificationType.Error)
                }
                
            })
        }
    }
    
    @IBAction func favoriteAction(sender: AnyObject) {
        var btn = sender as UIButton
        var currentTweet = self.tweets[btn.tag]
        btn.selected = !currentTweet.favorited
        TwitterClient.sharedInstance.toggleFavoriteTweetWithCompletion(currentTweet,
            completion: { (tweet, error) -> Void in
                if (tweet != nil) {
                    self.tweets[btn.tag].favorited = tweet.favorited
                } else {
                    btn.selected = currentTweet.favorited
                    TSMessage.showNotificationWithTitle("Error favoriting tweet", type: TSMessageNotificationType.Error)                    
                }
            }
        )
    }
    
    /* === LOADING SPINNER METHODS === */
    
    func showLoadingSpinner() {
        let loading = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loading.mode = MBProgressHUDModeDeterminate
        loading.color = self.navigationController?.navigationBar.backgroundColor
        loading.labelText = "Loading...";
    }
    
    /* === REFRESH CONTROL METHODS === */
    
    func setRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.blueColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName : UIColor.blueColor()])
        self.refreshControl.addTarget(self, action: Selector("refresh:"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func refresh(sender: AnyObject) {
        homeTimeline()
    }
    
}
