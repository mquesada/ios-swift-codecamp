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
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.retweetBtn.enabled = !tweet.retweeted

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
        }
    }

}
