//
//  TweetsViewController.swift
//  twitter
//
//  Created by Maricel Quesada on 10/18/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TimelineDelegate {
    
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
        
        self.tableView.estimatedRowHeight = 125
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        TSMessage.setDefaultViewController(self)
        
        setRefreshControl()
        
        loadTimeline()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTimeline() {
    }
    
    func loadMoreTweets() {
    }
    
    func addTweetToTimeline(tweet: Tweet) {
        self.tweets.insert(tweet, atIndex: 0)
        self.tableView.reloadData()
    }
    
    func updateTweetInTimeline(tweet: Tweet, index: Int) {
        self.tweets[index] = tweet
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
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "onProfileTab:")
        cell.profileImageView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row + 5 >= self.tweets.count && !self.loading) {
            loadMoreTweets()
        }
    }
    
    func onProfileTab(gesture: UITapGestureRecognizer) {
        var profileImageView = gesture.view as UIImageView
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var profileController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
        
        var tweet = self.tweets[profileImageView.tag]
        if (tweet.isRetweet) {
            profileController.user = tweet.embeddedTwitted.user
        } else {
            profileController.user = tweet.user
        }

        self.navigationController?.pushViewController(profileController, animated: true)
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
        var currentTweet = self.tweets[btn.tag]
        btn.selected = !currentTweet.retweeted
        if (!currentTweet.retweeted) {
            TwitterClient.sharedInstance.retweetWithCompletion(currentTweet, completion: { (tweet, error) -> Void in
                if (tweet != nil) {
                    self.tweets[btn.tag].retweeted = tweet.retweeted
                    self.tweets[btn.tag].retweetCount = tweet.retweetCount
                    btn.selected = tweet.retweeted
                } else {
                    btn.selected = currentTweet.retweeted
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
                    self.tweets[btn.tag].favoritesCount = tweet.favoritesCount
                } else {
                    btn.selected = currentTweet.favorited
                    TSMessage.showNotificationWithTitle("Error favoriting tweet", type: TSMessageNotificationType.Error)
                }
            }
        )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tweetDetailsSegue") {
            var detailsController = segue.destinationViewController as TweetDetailsViewController
            var cell = sender as TweetCell
            detailsController.tweet = cell.tweet
            detailsController.index = cell.index!
            detailsController.timelineDelegate = self
        } else if (segue.identifier == "tweetSegue") {
            var tweetController = segue.destinationViewController as TweetViewController
            tweetController.timelineDelegate = self
        } else if (segue.identifier == "replyTweetFromList") {
            var detailsController = segue.destinationViewController as TweetViewController
            var btn = sender as UIButton
            var tweet = self.tweets[btn.tag]
            detailsController.tweetReplyId = tweet.id
            detailsController.tweetReplyUsername = tweet.user.screenName
            detailsController.timelineDelegate = self
        }
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
        loadTimeline()
    }
    
}
