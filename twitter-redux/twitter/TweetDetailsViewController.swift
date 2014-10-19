//
//  TweetDetailsViewController.swift
//  twitter
//
//  Created by Maricel Quesada on 10/11/14.
//  Copyright (c) 2014 Maricel Quesada. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var retweetBtn: UIButton!
    
    @IBOutlet weak var retweetedImageView: UIImageView!
    @IBOutlet weak var retweetedByLabel: UILabel!
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    var tweet: Tweet!
    var index = 0
    var timelineDelegate: TimelineDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.retweetedByLabel.hidden = true
        self.retweetedImageView.hidden = true
        self.topMarginConstraint.constant = 15

        if (self.tweet.isRetweet) {
            setData(self.tweet.embeddedTwitted, retweetUser: self.tweet.user)
        } else {
            setData(self.tweet, retweetUser: nil)
        }

    }
    
    func setData(tweet: Tweet, retweetUser: User?) {
        self.profileImageView.setImageWithURL(tweet.user.profileImageUrl)
        self.profileImageView.layer.cornerRadius = 10.0
        self.profileImageView.clipsToBounds = true
        
        self.nameLabel.text = tweet.user.name
        self.usernameLabel.text = "@\(tweet.user.screenName)"
        self.tweetTextLabel.text = tweet.text
        self.createdAtLabel.text = tweet.createdAtString
        self.retweetsLabel.text = "\(tweet.retweetCount)"
        self.favoritesLabel.text = "\(tweet.favoritesCount)"
        
        self.favoriteBtn.setImage(UIImage(named: "favoriteEnabled"), forState: UIControlState.Selected)
        self.favoriteBtn.selected = tweet.favorited
        
        self.retweetBtn.setImage(UIImage(named: "retweetEnabled"), forState: UIControlState.Selected)
        self.retweetBtn.selected = tweet.retweeted
//        self.retweetBtn.enabled = !tweet.retweeted
        
        if (retweetUser != nil) {
            self.retweetedByLabel.text = "\(retweetUser!.name) retweeted"
            self.retweetedByLabel.hidden = false
            self.retweetedImageView.hidden = false
            self.topMarginConstraint.constant = 30
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    

    @IBAction func replyAction(sender: AnyObject) {
        self.performSegueWithIdentifier("replyTweetFromDetails", sender: self)
    }
    
    @IBAction func favoriteAction(sender: AnyObject) {
        var btn = sender as UIButton
        btn.selected = !self.tweet.favorited
        TwitterClient.sharedInstance.toggleFavoriteTweetWithCompletion(
            self.tweet,
            completion: { (tweet, error) -> Void in
                if (tweet != nil) {
                    self.tweet = tweet
                    self.tweet.favoritesCount = tweet.favoritesCount                    
                    self.favoritesLabel.text = "\(self.tweet.favoritesCount)"
                    self.timelineDelegate.updateTweetInTimeline(self.tweet, index: self.index)
                } else {
                    btn.selected = self.tweet.favorited
                    TSMessage.showNotificationWithTitle("Error favoriting tweet", type: TSMessageNotificationType.Error)
                }
            }
        )
    }
    
    @IBAction func retweetAction(sender: AnyObject) {
        if (!self.tweet.retweeted) {
            TwitterClient.sharedInstance.retweetWithCompletion(self.tweet,
                completion: { (tweet, error) -> Void in
                    if (tweet != nil) {
                        self.tweet = tweet
                        self.retweetsLabel.text = "\(self.tweet.retweetCount)"
                        self.retweetBtn.selected = self.tweet.retweeted
                        self.timelineDelegate.updateTweetInTimeline(self.tweet, index: self.index)
                    } else {
                        TSMessage.showNotificationWithTitle("Error while retweeting", type: TSMessageNotificationType.Error)
                    }
                }
            )
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "replyTweetFromDetails") {
            var detailsController = segue.destinationViewController as TweetViewController
            detailsController.tweetReplyId = self.tweet.id
            detailsController.tweetReplyUsername = self.tweet.user.screenName
            detailsController.timelineDelegate = self.timelineDelegate
        }
    }

}
